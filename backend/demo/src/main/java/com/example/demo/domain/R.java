package com.example.demo.domain;

// Result 返回结果信息类
public class R<T> {

    private String msg; // 提示信息

    private Integer code; // 自定义状态码

    private T data; // 返回的数据

    public static <T> R<T> to(String msg, Integer code) {
        R<T> r = new R<>();
        r.setMsg(msg);
        r.setCode(code);
        return r;
    }

    public static <T> R<T> to(String msg, Integer code, T data) {
        R<T> r = new R<>();
        r.setMsg(msg);
        r.setCode(code);
        r.setData(data);
        return r;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }


}
