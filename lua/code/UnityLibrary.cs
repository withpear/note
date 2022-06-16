using AOT;
using System;
using UnityEngine;
using Uvplay.Lua.Core;
using UniRx;
using System.Collections.Generic;

public static class UnityLibrary
{
    [MonoPInvokeCallback(typeof(Lua.CFunction))]
    public static int Luaopen_unity(IntPtr state)
    {
        GlobalEnv.NewLib(state, unitylib);
        return 1;
    }

    static List<LuaL.Reg> unitylib = new List<LuaL.Reg>{
            new LuaL.Reg("TimeoutAsync", TimeoutAsync),
            new LuaL.Reg("Log", Log),
            new LuaL.Reg(null, null),
        };

    [MonoPInvokeCallback(typeof(Lua.CFunction))]
    static int TimeoutAsync(IntPtr state)
    {
        IntPtr co = LuaStack.GetThread(state, 1);
        float time = (float)LuaStack.GetNumber(state, 2);

        Observable.Timer(TimeSpan.FromSeconds(time)).Subscribe(x => {
            LuaThread.ResumeSubthread(co, state, 0, out _);

        });
        return 0;
    }

    [MonoPInvokeCallback(typeof(Lua.CFunction))]
    static int Log(IntPtr state)
    {
        string log = LuaStack.GetString(state, -1);
        Debug.Log(log);
        return 0;
    }
}

