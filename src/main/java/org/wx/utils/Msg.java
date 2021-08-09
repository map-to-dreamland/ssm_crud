package org.wx.utils;

import com.github.pagehelper.PageInfo;

import java.util.HashMap;
import java.util.Map;

/*
* 工具类，用于向客户端返回信息，比较有通用性
* */
public class Msg {
    //状态码，成功返回100，失败返回-100
    private int code;
    //成功或失败返回的信息
    private String msg;
    //携带的数据
    //这里应该实例化，不然添加的时候会报空指针异常
    //或者在add方法里实例化
    private Map<String,Object> extend;


    public static Msg success() {
        Msg msg = new Msg();
        msg.setCode(100);
        msg.setMsg("处理成功");
        return msg;
    }
    public static Msg fail() {
        Msg msg = new Msg();
        msg.setCode(-100);
        msg.setMsg("处理失败");
        return msg;
    }
    public Msg add(String key, Object value) {
        //因为是在success或fail方法返回的对象上增数据，不能再新建对象了，用this
        this.extend = new HashMap<String,Object>();
        this.extend.put(key,value);
        return this;
    }


    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }

}
