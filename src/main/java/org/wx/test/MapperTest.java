package org.wx.test;


import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.wx.bean.Department;
import org.wx.bean.Employee;
import org.wx.dao.DepartmentMapper;
import org.wx.dao.EmployeeMapper;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring/applicationContext.xml"})
public class MapperTest {
    @Autowired
    private EmployeeMapper employeeMapper;
    @Autowired
    private DepartmentMapper departmentMapper;
    @Test
    public void testCRUD() {
       /* ApplicationContext context =
                new ClassPathXmlApplicationContext("spring/applicationContext.xml");
        //获取mapper
        EmployeeMapper bean = context.getBean(EmployeeMapper.class);
        bean.selectByPrimaryKeyWithDept(1);
        System.out.println(bean.selectByPrimaryKeyWithDept(1));*/
        //Spring单元测试
        System.out.println(employeeMapper);
        //employeeMapper.selectByPrimaryKey(1);
        System.out.println(employeeMapper.selectByPrimaryKey(1));
        Department department = new Department(null,"人事");
        Employee employee = new Employee(null,"alima","nan","email",1,department);

        //employeeMapper.insertSelective(employee);
        //departmentMapper.insertSelective(department);

       // System.out.println(employeeMapper.selectByExample(null));
        for (int i=0; i<100; i++) {
            employeeMapper.insertSelective(employee);
        }
    }
}
