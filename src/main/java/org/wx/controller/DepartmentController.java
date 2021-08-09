package org.wx.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.wx.bean.Department;
import org.wx.service.DepartmentService;
import org.wx.utils.Msg;

import javax.annotation.Resource;
import java.util.List;

@Controller
public class DepartmentController {
    @Resource
    DepartmentService departmentService;

    //ajax查询所有部门信息
    @ResponseBody
    @RequestMapping("/depts")
    public Msg getDepts() {
        List<Department> depts = departmentService.getAll();
        return Msg.success().add("depts",depts);
    }
}
