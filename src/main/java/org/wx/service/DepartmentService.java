package org.wx.service;

import org.springframework.stereotype.Service;
import org.wx.bean.Department;
import org.wx.dao.DepartmentMapper;

import javax.annotation.Resource;
import java.util.List;

@Service
public class DepartmentService {
    @Resource
    DepartmentMapper departmentMapper;

    //查询所有部门信息
    public List<Department> getAll() {
        return departmentMapper.selectByExample(null);
    }
}
