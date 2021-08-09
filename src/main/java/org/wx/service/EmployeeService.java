package org.wx.service;

import org.springframework.stereotype.Service;
import org.wx.bean.Employee;
import org.wx.bean.EmployeeExample;
import org.wx.dao.EmployeeMapper;

import javax.annotation.Resource;
import java.util.List;

@Service
public class EmployeeService {
    @Resource
    EmployeeMapper employeeMapper;

    //查询所有员工信息
    public List<Employee> getAll() {
       return employeeMapper.selectByExampleWithDept(null);
    }
    //增加一条员工数据
    public boolean addEmp(Employee employee) {
        return employeeMapper.insertSelective(employee) > 0;
    }
    //校验用户名是否可用 true代表可用，false代表不可用
    public boolean checkUser(String empName) {
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long count = employeeMapper.countByExample(example);
        return count == 0;
    }
//按id查询一条员工数据
    public Employee getEmp(Integer id) {
        return employeeMapper.selectByPrimaryKey(id);
    }
//员工更新
    public boolean updateEmp(Employee employee) {
        return employeeMapper.updateByPrimaryKeySelective(employee) > 0;
    }
    /*
     * 删除单个员工
     * */
    public boolean deleteEmp(Integer id) {
        return employeeMapper.deleteByPrimaryKey(id) > 0;
    }
/*
* 删除多个员工
* */
    public boolean deleteEmps(List<Integer> listIds) {
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        //delete from xxx where emp_id in(1,2,3);
        criteria.andEmpIdIn(listIds);
        return employeeMapper.deleteByExample(example) > 0;
    }
}
