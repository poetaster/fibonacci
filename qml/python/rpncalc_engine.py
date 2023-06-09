import sys
import platform
import threading
from enum import Enum, IntEnum, unique

(major, minor, micro, release, serial) = sys.version_info
sys.path.append("/usr/share/harbour-fibonacci/lib/python" + str(major) + "." + str(minor) + "/site-packages/");
#sys.path.append("/usr/share/harbour-fibonacci/lib/");

import pyotherside
from rpncalc_common import *
import rpncalc_mpmath_backend as mpmathBackend
sympyBackend = None

class Engine:

    def __init__(self, beautifier):
        self.engineLoaded = False
        self.extendedFunctionLoaded = False
        self.stack = []
        self.currentOperand = ""

        self.undoStack = []
        self.undoCurrentOperand = ""

        self.beautifier = beautifier
        self.trigUnit = TrigUnit.Radians

        self._autoSimplify = True
        self._symbolicMode = True
        self._rationalMode = True

        self._backends = [mpmathBackend]
        self._backends[0].trigUnit = self.trigUnit

        self.beautifier.setBackends(self._backends)

        t = threading.Timer(0.1, self.loadEngine)
        t.start()


    def loadEngine(self):

        global sympyBackend
        import rpncalc_sympy_backend as sympyBackend
        sympyBackend.trigUnit = self.trigUnit
        self._backends.insert(0, sympyBackend)

        print("Engine loaded")
        self.engineLoaded = True
        self.extendedFunctionLoaded = True

        pyotherside.send("EngineLoaded")

    def setSymbolicMode(self, enabled):
        if self._symbolicMode != enabled:
            self._symbolicMode = enabled
            self.beautifier.setSymbolicMode(enabled)
            self.stackChanged()

    def setRationalMode(self, enabled):
        if self._rationalMode != enabled:
            self._rationalMode = enabled
            self.beautifier.setRationalMode(enabled)

    def setAutoSimplify(self, enabled):
        if self._autoSimplify != enabled:
            self._autoSimplify = enabled

    def setBeautifierPrecision(self, prec):
        self.beautifier.setPrecision(prec)
        self.stackChanged()

    def getStack(self):
        return self.stack

    def processInput(self, input, type):

        try:
            if type == "number":
                self.currentOperand += input
                self.currentOperandChanged()
            elif type == "exp":
                if self.currentOperand == "":
                    self.currentOperand += "1e"
                else:
                    self.currentOperand += "e"
                self.currentOperandChanged()
            elif type == "stack":
                self.stackInputProcessor(input)
            elif type == "operation":
                self.operationInputProcessor(input)
            elif type == "symbol":
                self.pushUndo()

                if self._backends[0].features & Feature.Symbolic:
                    expr = self._backends[0].addSymbol(input)
                self.stackPush(expr) # nothing to pop
            elif type == "constant":
                self.constantInputProcessor(input)
            elif type == "real":
                if '.' not in self.currentOperand:
                    self.currentOperand += input
                    self.currentOperandChanged()
            elif type == "function":
                self.functionInputProcessor(input)
            elif type == "dice":
                pyotherside.send("symbolsPush", "Dices", [{"displayName": "d4", "name": "d4", "type": "function"},
                    {"displayName": "d6", "name": "d6", "type": "function"},
                    {"displayName": "d8", "name": "d8", "type": "function"},
                    {"displayName": "d10", "name": "d10", "type": "function"},
                    {"displayName": "d12", "name": "d12", "type": "function"},
                    {"displayName": "d20", "name": "d20", "type": "function"},
                    {"displayName": "d100", "name": "d100", "type": "function"}
                    ])
            elif type == "constantList":
                pyotherside.send("symbolsPush", "Constants", self._backends[0].constantsArray)
            else:
                print(type)
        except ExpressionNotValidException as err:
            print(err)
            pyotherside.send("ExpressionNotValidException")
        except NotEnoughOperandsException as err:
            print(err)
            pyotherside.send("NotEnoughOperandsException", err.nbRequested, err.nbAvailable)
        except WrongOperandsException as err:
            print(err)
            pyotherside.send("WrongOperandsException", err.expectedTypes, err.nb)
        except BackendException as err:
            print(err)
            pyotherside.send("BackendException")

    def stringExpressionValid(self, str):
        valid = True
        if str != "":
            valid = self._backends[0].stringExpressionValid(str)
        return valid

    def currentOperandValid(self):
        return self.stringExpressionValid(self.currentOperand)

    def currentOperandLastChr(self):
        lastChr = ""
        if self.currentOperand != "":
            lastChr = self.currentOperand[-1:]

        return lastChr

    def changeTrigonometricUnit(self, unit):
        print("Changing unit to " + str(unit))
        if unit == "Radian":
            self.trigUnit = TrigUnit.Radians
        elif unit == "Degree":
            self.trigUnit = TrigUnit.Degrees
        elif unit == "Gradient":
            self.trigUnit = TrigUnit.Gradients
        else:
            print("Invalid unit")

        for b in self._backends:
            b.trigUnit = self.trigUnit

    def pushUndo(self):
        self.undoStack = self.stack.copy()
        self.undoCurrentOperand = self.currentOperand

    def stackInputProcessor(self, input):

        if input == "enter":
            self.pushUndo()

            expr = None
            if self.currentOperand != "":
                if self.currentOperandValid() is False:
                    raise ExpressionNotValidException()

                expr = None
                if self._backends[0].features & Feature.StringConversion:
                    if self._backends[0].features & Feature.Rational:
                        expr = self._backends[0].stringToExpr(self.currentOperand, self._rationalMode)
                    else:
                        expr = self._backends[0].stringToExpr(self.currentOperand)
                else:
                    raise NotSupportedException()

            elif len(self.stack) > 0:
                expr = self.stack[0]

            if expr is not None:
                self.stackPush(expr) # nothing to pop
        elif input == "swap":

            if len(self.stack) > 1:
                self.pushUndo()

                op0 = self.stack[0]
                op1 = self.stack[1]

                self.stack[0] = op1;
                self.stack[1] = op0;

                self.stackChanged()
        elif input == "drop":
            self.stackDropFirst()
        elif input == "clr":
            self.stackDropAll()
        elif input == "undo":
            expr = None
            if self.undoCurrentOperand != "":
                if self.stringExpressionValid(self.undoCurrentOperand) is False:
                    raise UndoErrorException()

                expr = None
                if self._backends[0].features & Feature.StringConversion:
                    if self._backends[0].features & Feature.Rational:
                        expr = self._backends[0].stringToExpr(self.undoCurrentOperand, self._rationalMode)
                    else:
                        expr = self._backends[0].stringToExpr(self.undoCurrentOperand)
                else:
                    raise NotSupportedException()

            self.stack = self.undoStack.copy()
            if expr is not None:
                self.stackPush(expr, notify=False) # do not notify, full stack change below

            self.undoCurrentOperand = ""
            self.currentOperandChanged()
            self.stackChanged()
        elif input == "R-":
            if len(self.stack) > 1:
                self.stack.append(self.stack.pop(0))
                self.stackChanged()
        elif input == "R+":
            if len(self.stack) > 1:
                self.stack.insert(0, self.stack.pop())
                self.stackChanged()

    def functionInputProcessor(self, input):
        o = self._backends[0].objs[input]

        if o["undo"] is True:
            self.pushUndo()

        nbOperands = o["operands"]
        ops = self.getOperands(nbOperands, o["operandTypes"])

        nbToPop = nbOperands
        if self.currentOperand != "":
            if nbToPop > 0:
                nbToPop = nbToPop - 1

        try:
            expr = o["func"](ops)
        except:
            self.stackPush(ops, notify=False) # operation failed, UI stack should be in good shape
            raise BackendException()

        self.stackPush(expr, pop=nbToPop)

    def operationInputProcessor(self, input):

        if input == "neg" and self.currentOperandLastChr() == "e":
            self.currentOperand += "-"
            self.currentOperandChanged()
            return

        o = self._backends[0].objs[input]

        if o["undo"] is True:
            self.pushUndo()

        nbOperands = o["operands"]
        ops = self.getOperands(nbOperands, o["operandTypes"])

        nbToPop = nbOperands
        if self.currentOperand != "":
            if nbToPop > 0:
                nbToPop = nbToPop - 1

        try:
            expr = o["func"](ops)
        except Exception as err:
            print(err)
            self.stackPush(ops, notify=False) # operation failed, UI stack should be in good shape
            raise BackendException()

        self.stackPush(expr, pop=nbToPop)

    def constantInputProcessor(self, input):

        self.pushUndo()
        expr = self._backends[0].constants[input]
        self.stackPush(expr) # nothing to pop

    def getOperands(self, nb=2, types=OperandType.All):
        nbAvailable = 0

        if self.currentOperand != "":
            nbAvailable = 1
        nbAvailable += len(self.stack)

        if nb == -1:
            nb = len(self.stack)
            if self.currentOperand != "":
                nb += 1

        if nb == 0:
            return ()
        elif nb <= nbAvailable:
            ops = ()
            nbToPop = 0;
            rangeStart = nb;
            if self.currentOperand != "":
                rangeStart -= 1;

            for i in reversed(range(0, rangeStart)):
                ops = ops + (self.stack[i],)
                nbToPop += 1

            if len(ops) < nb:
                if self.currentOperandValid() is False:
                    raise ExpressionNotValidException()

                if self._backends[0].features & Feature.StringConversion:
                    if self._backends[0].features & Feature.Rational:
                        ops = ops + (self._backends[0].stringToExpr(self.currentOperand, self._rationalMode),)
                    else:
                        ops = ops + (self._backends[0].stringToExpr(self.currentOperand),)
                else:
                    raise NotSupportedException()

            typesOk = True
            exposedExceptionNb = 0
            try: # types is iterable, multiple types given. Checking against each operand.
                i = 0
                for t in types:
                    if len(types) != len(ops):  # late checking for length, because we had to know that it was iterable before
                        raise CannotVerifyOperandsTypeException()
                    typesOk = typesOk and self.__verifyType(ops[i], t)
                    i += 1
            except TypeError: # types is not iterable
                for o in ops:
                    typesOk = typesOk and self.__verifyType(o, types)
                exposedExceptionNb = nb  # expose number of required operand type to exception, since we do not have details.

            if typesOk is True:
                self.__stackPop(nbToPop)
                if len(ops) == 1:
                    return ops[0]
                else:
                    return ops
            else:
                raise WrongOperandsException(types, exposedExceptionNb)

        else:
            raise NotEnoughOperandsException(nb, nbAvailable)

    def __verifyType(self, op, type):

        if type == OperandType.All:
            return True
        elif type == OperandType.Integer:
            return op.is_integer
        elif type == OperandType.Float:
            return op.is_real

    def __stackPop(self, nb = 1):
        for i in range(0, nb):
            self.stack.pop(0)

    def stackPush(self, expr, notify=True, pop=0):
        try:
            _ = (e for e in expr)  # check for iterable

            for i in expr:
                self.stack.insert(0, i)

        except TypeError:
            self.stack.insert(0, expr)

        self.clearCurrentOperand()

        if notify is True:
            el = self.beautifier.beautifyElement(expr, len(self.stack))
            pyotherside.send("stackPopPush", pop, el)

    def stackDropFirst(self):
        if len(self.stack) > 0:
            self.stack.pop(0)
            pyotherside.send("stackPop", 1)

    def stackDropAll(self):
        if len(self.stack) > 0:
            self.stack.clear()
            pyotherside.send("stackPop", -1)

    def stackDrop(self, idx):
        if len(self.stack) > int(idx):
            self.stack.pop(int(idx))
            self.stackChanged()

    def stackPick(self, idx):
        if len(self.stack) > int(idx):
            expr = self.stack.pop(int(idx))
            self.stack.insert(0, expr)
            self.stackChanged()

    def strToNumber(self, str):
        if "." in str:
            return float(self.currentOperand)
        else:
            return int(self.currentOperand)

    def clearCurrentOperand(self):
        self.currentOperand = "";
        self.currentOperandChanged();

    def delLastOperandCharacter(self):
        self.currentOperand = self.currentOperand[:-1]
        self.currentOperandChanged();

    def currentOperandChanged(self):
        if self.engineLoaded is True:
            pyotherside.send("currentOperand", self.currentOperand, self.currentOperandValid())
        else:
            pyotherside.send("currentOperand", self.currentOperand, True)

    def stackChanged(self):
        res = self.beautifier.beautifyStack(self.stack)
        pyotherside.send("newStack", res)

class StackManager:

    def __init__(self):
        pass

class SimpleBeautifier:

    def __init__(self):
        self.precision = 4
        self._symbolicMode = True
        self._rationalMode = True
        self._backends = None

    def setSymbolicMode(self, enabled):
        if enabled != self._symbolicMode:
            self._symbolicMode = enabled

    def setRationalMode(self, enabled):
        if enabled != self._rationalMode:
            self._rationalMode = enabled


    def setPrecision(self, prec):
        self.precision = prec

    def setBackends(self, e):
        self._backends = e

    def beautifyNumber(self, number):
        pass

    def beautifyElement(self, el, index=-1):
        expr = None

        for b in self._backends:
            try:
                if (self._symbolicMode is True) and (b.features & Feature.Symbolic):
                    expr = b.exprToStr(el, self.precision)
                else:
                    expr = str(b.eval(el, self.precision))

                break

            except UnsupportedBackendExpressionException:
                if b is self._backends[-1]:
                    raise UnsupportedBackendExpressionException()
                else:
                    continue

        stackEl = {"index": index, "expr": expr}
        return stackEl

    def beautifyStack(self, stack):
        model = []

        index = 1
        for i in stack:
            el = self.beautifyElement(i, index)

            model.append(el)
            index += 1

        return model


beauty = SimpleBeautifier()
engine = Engine(beauty)
