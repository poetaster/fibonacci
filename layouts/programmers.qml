/*
 * Copyright (C) 2012-2013 Jolla ltd and/or its subsidiary(-ies). All rights reserved.
 * Copyright (C) 2023 Mark Washeim
 *
 * Contact: Pekka Vuorela <pekka.vuorela@jollamobile.com>
 * Contact: Mark Washeim <blueprint@poetaster.de>
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list
 * of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list
 * of conditions and the following disclaimer in the documentation and/or other materials
 * provided with the distribution.
 * Neither the name of Jolla Ltd nor the names of its contributors may be
 * used to endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

import QtQuick 2.0
import ".."

KeyboardLayout {
    splitSupported: false

    KeyboardRow {
        CharacterKey { caption: "1"; captionShifted: "q"; symView: "1"; symView2: "&" }
        CharacterKey { caption: "2"; captionShifted: "w"; symView: "2"; symView2: "" }
        CharacterKey { caption: "3"; captionShifted: "e"; symView: "3"; symView2: "or" }
        CharacterKey { caption: "4"; captionShifted: "r"; symView: "4"; symView2: "" }
        CharacterKey { caption: "5"; captionShifted: "t"; symView: "5"; symView2: "nor" }
        CharacterKey { caption: "+"; captionShifted: "y"; symView: "+="; symView2: "" }
        CharacterKey { caption: "-"; captionShifted: "u"; symView: "-="; symView2: "xnor" }
        CharacterKey { caption: "*"; captionShifted: "i"; symView: "*="; symView2: "" }
        CharacterKey { caption: "/"; captionShifted: "o"; symView: "/="; symView2: "nand" }
        CharacterKey { caption: "="; captionShifted: "p"; symView: ":="; symView2: "" }
    }

    KeyboardRow {
        CharacterKey { caption: "6"; captionShifted: "a"; symView: "6"; symView2: "sin" }
        CharacterKey { caption: "7"; captionShifted: "s"; symView: "7"; symView2: "" }
        CharacterKey { caption: "8"; captionShifted: "d"; symView: "8"; symView2: "cos" }
        CharacterKey { caption: "9"; captionShifted: "f"; symView: "9"; symView2: "" }
        CharacterKey { caption: "0"; captionShifted: "g"; symView: "0"; symView2: "tan" }
        CharacterKey { caption: "<"; captionShifted: "h"; symView: ">"; symView2: "" }
        CharacterKey { caption: ">"; captionShifted: "j"; symView: "<"; symView2: "log" }
        CharacterKey { caption: "^"; captionShifted: "k"; symView: "φ"; symView2: "φ" }
        CharacterKey { caption: "√"; captionShifted: "l"; symView: "√"; symView2: "√" }
        CharacterKey { caption: "π"; captionShifted: ":="; symView: "π"; symView2: "π" }
    }

    KeyboardRow {
        CharacterKey { caption: "["; captionShifted: "z"; symView: "["; symView2: "log10" }
        CharacterKey { caption: "]"; captionShifted: "x"; symView: "]"; symView2: "" }
        CharacterKey { caption: "{"; captionShifted: "c"; symView: "{"; symView2: "log2" }
        CharacterKey { caption: "}"; captionShifted: "v"; symView: "}"; symView2: "" }
        CharacterKey { caption: "("; captionShifted: "b"; symView: "("; symView2: "pow" }
        CharacterKey { caption: ")"; captionShifted: "n"; symView: ")"; symView2: "" }
        CharacterKey { caption: "<"; captionShifted: "m"; symView: "π"; symView2: "sum" }
        CharacterKey { caption: ">"; captionShifted: "["; symView: "√"; symView2: "" }
        CharacterKey { caption: ";"; captionShifted: "]"; symView: ";"; symView2: "" }
    }

    KeyboardRow {
        ShiftKey {}
        CharacterKey { caption: "var"; captionShifted: "? :"; symView: "<="; symView2: "root" }
        CharacterKey { caption: "for"; captionShifted: "~"; symView: ">="; symView2: "" }
        CharacterKey { caption: "if"; captionShifted: "else"; symView: ":"; symView2: "max" }
        CharacterKey { caption: "while"; captionShifted: ";"; symView: ";"; symView2: ";" }
        CharacterKey { caption: ":="; captionShifted: ":="; symView: ":="; symView2: ":=" }
        BackspaceKey {}
    }

    SpacebarRow {}
}

