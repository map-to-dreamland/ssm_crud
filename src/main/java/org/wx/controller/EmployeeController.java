package org.wx.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.wx.bean.Department;
import org.wx.bean.Employee;
import org.wx.service.DepartmentService;
import org.wx.service.EmployeeService;
import org.wx.utils.Msg;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class EmployeeController {
    @Resource
    EmployeeService employeeService;

    //ajax方式，返回json数据
    @ResponseBody
    @RequestMapping("/emps")
    public Msg getEmps(@RequestParam(value = "pn",defaultValue = "1") Integer pn) {
        //传入页码，每页的大小，调用分页插件的方法
        PageHelper.startPage(pn,5);
        //startPage紧跟的这个就是分页查询
        List<Employee> emps = employeeService.getAll();
        //将查出的信息用pageInfo包装交给页面
        PageInfo pageInfo = new PageInfo(emps,5);
        return Msg.success().add("pageInfo",pageInfo);
    }
    /*原生方式，返回页面
    //分页查询
    @RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1") Integer pn,
                          Model model) {
        //传入页码，每页的大小，调用分页插件的方法
        PageHelper.startPage(pn,5);
        //startPage紧跟的这个就是分页查询
        List<Employee> emps = employeeService.getAll();
        //将查出的信息用pageInfo包装交给页面
        PageInfo pageInfo = new PageInfo(emps,5);
        model.addAttribute("pageInfo",pageInfo);
        return "list";
    }*/
    //restful风格增删改
    /*
     * 客户端请求 emp      POST 即为增加
     *           emp/id  DELETE 为删除
     *           emp/id   PUT 为修改
     *           emp/id  GET 为查询一条
     *           emps    GET查询所有
    * */
    /*
    * 增加用户，后端数据校验
    * */
    @ResponseBody
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    public Msg addEmp(@Valid Employee employee, BindingResult result) {
        if (result.hasErrors()) {
            Map<String,Object> errorMap = new HashMap<String,Object>();
            List<FieldError> fieldErrors = result.getFieldErrors();
            for (FieldError fieldError : fieldErrors) {
                errorMap.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorFiled",errorMap);
        } else {
            employeeService.addEmp(employee);
            return Msg.success();
        }
    }
/*
* 检查用户名是否可用
* */
    @ResponseBody
    @RequestMapping("/checkUser")
    public Msg checkUser(String empName) {
        //先判断用户名是否是合法的表达式
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if(!empName.matches(regx)) {
            return Msg.fail().add("va_msg","用户名可以是6-16位英文字母数字组合或2-5位中文");
        }
        //数据库用户名校验
        boolean flag = employeeService.checkUser(empName);
        return flag ? Msg.success() : Msg.fail().add("va_msg","用户名不可用");
    }
/*
* 按id查询一条员工数据
* */
    @ResponseBody
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    public Msg getEmp(@PathVariable Integer id) {
        Employee emp = employeeService.getEmp(id);
        return Msg.success().add("emp",emp);
    }
    /*
    *员工更新
    * */
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    public Msg updateEmp(Employee employee) {
        employeeService.updateEmp(employee);
        return Msg.success();
    }
    /*
    * 删除员工方法，如果前面传来的值包含"-"号，即为批量删除
    * 如果不包含，删除单个员工
    * */
    @ResponseBody
    @RequestMapping(value = "/emp/{empIds}",method = RequestMethod.DELETE)
    public Msg deleteEmp(@PathVariable String empIds) {
        if (empIds.contains("-")) {
            String[] splitIds = empIds.split("-");
            List<Integer> listIds = new ArrayList<Integer>();
            for (String id : splitIds) {
                listIds.add(Integer.parseInt(id));
            }
            employeeService.deleteEmps(listIds);
        } else {
            employeeService.deleteEmp(Integer.parseInt(empIds));
        }
        return Msg.success();
    }
}
