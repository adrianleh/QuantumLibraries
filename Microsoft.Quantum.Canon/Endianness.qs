﻿// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

namespace Microsoft.Quantum.Canon {

    /// # Summary
    /// Reorders the qubits in a register to obtain a new
    /// qubit register.
    operation ReverseRegister(register : Qubit[])  : Qubit[]
    {
        body {
            mutable reversed = new Qubit[Length(register)];

            for (idxQubit in 0..Length(register) - 1) {
                let thisQubit = register[Length(register) - idxQubit + 1];
                set reversed[idxQubit] = thisQubit;
            }

            return reversed;
        }
    }

    /// # Summary
    /// Uses SWAP gates to reverse the order of the qubits in
    /// a register.
    operation SwapReverseRegister(register : Qubit[])  : ()
    {
        body {
            // TODO
        }

        adjoint self
        controlled auto
        controlled adjoint auto
    }

    newtype LittleEndian = Qubit[];
    newtype BigEndian = Qubit[];

    // The next two operations are just to specify the more
    // specific user-defined types LE and BE so that we can partially apply
    // to obtain (LittleEndian => ()) instead of (Qubit[] => ()).

    operation ApplyReversedOpLE(op : (LittleEndian => ()),  register : BigEndian)  : ()
    {
        body {
            let bareReversed = ReverseRegister(register);
            let reversed = LittleEndian(bareReversed);
            op(reversed);
        }
    }

    operation ApplyReversedOpBE(op : (BigEndian => ()),  register : LittleEndian)  : ()
    {
        body {
            let bareReversed = ReverseRegister(register);
            let reversed = BigEndian(bareReversed);
            op(reversed);
        }
    }

    // We finish by providing two wrappers that partially
    // apply the two operations above for convenience.
    operation LittleOpToBigOp(op : (LittleEndian => ()))  : (BigEndian => ())
    {
        body {
            return ApplyReversedOpLE(op, _);
        }
    }

    operation BigOpToLittleOp(op : (BigEndian => ()))  : (LittleEndian => ())
    {
        body {
            return ApplyReversedOpBE(op, _);
        }
    }

}
