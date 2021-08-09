<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <%
        pageContext.setAttribute("APP_PATH",request.getContextPath());
        //前面有“/”号后面后面没有，所有使用时要加上
    %>
    <%--    import jquery,jquery必须在bootstrap前面引入--%>
    <script src="${APP_PATH}/static/js/jquery-3.6.0.min.js"></script>
    <%--   import bootstrap--%>
    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.4.1-dist/css/bootstrap.min.css">
    <script src="${APP_PATH}/static/bootstrap-3.4.1-dist/js/bootstrap.min.js"></script>
<script>
        $(document).ready(function () {
            //定义全局变量总记录数
            var totalRecord,currentPage;
            to_page(1);
            //发送ajax请求跳转页面的方法
            function to_page(pn) {
                $.ajax({
                    url:"${APP_PATH}/emps",
                    data:"pn="+pn,
                    type:"get",
                    success:function (result) {
                        //解析并显示员工数据
                        build_emps_table(result);
                        //解析并显示分页信息
                        build_page_info(result);
                        //解析显示分页条数据
                        build_page_nav(result);
                    }
                });
            }
            //解析并显示员工数据
            function build_emps_table(result) {
                //构建数据前先清空，防止分页里有多余数据
                $("#emps_table tbody").empty();
                var emps = result.extend.pageInfo.list;
                $.each(emps,function (index,item) {
                    var checkboxTD = $("<td></td>").append($("<input type='checkbox' class='check_item'></input>"));
                    var empIdTd = $("<td></td>").append(item.empId);
                    var empNameTd = $("<td></td>").append(item.empName);
                    var empGenderTd = $("<td></td>").append(item.empGender=='M' ? "男" : "女");
                    var empEmailTd = $("<td></td>").append(item.empEmail);
                    var empDeptTd = $("<td></td>").append(item.department.deptName);
                    //按钮，根据原来代码用dom生成          attr("editId",item.empId)为每一个编辑按钮加上员工id，便于查询
                    var editBnt = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn").attr("editId",item.empId)
                        .append("<span></span>").addClass("glyphicon glyphicon-pencil").append("编辑");
                    var deleteBnt = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn").attr("deleteId",item.empId)
                        .append("<span></span>").addClass("glyphicon glyphicon-trash").append("删除");
                    var operationTd = $("<td></td>").append(editBnt).append(" ").append(deleteBnt);
                    //append方法返回原来的元素
                    //empIdTd等是局部变量，empTd定义到循环外的话就不能用
                    var empTd = $("<tr></tr>").append(checkboxTD)
                        .append(empIdTd)
                        .append(empNameTd)
                        .append(empGenderTd)
                        .append(empEmailTd)
                        .append(empDeptTd)
                        .append(operationTd)
                        .appendTo("#emps_table tbody");
                })
            }
            //解析并显示分页信息
            function build_page_info(result) {
                //构建数据前先清空，防止多余数据
                $("#page_info").empty();
                var pageInfo = result.extend.pageInfo;
                $("#page_info").append("当前第"+pageInfo.pageNum+"页","共"+pageInfo.pages+"页,共有"+pageInfo.total+"条记录");
                totalRecord = pageInfo.total;
                currentPage = pageInfo.pageNum;
            }
            //解析显示分页条数据
            function build_page_nav(result) {
                //构建数据前先清空，防止多余数据
                $("#page_nav").empty();
                var pageInfo = result.extend.pageInfo;
                //首页
                var firstLi = $("<li></li>").append($("<a></a>").append("首页"));
                firstLi.click(function () {
                    to_page(1);
                })
                //上一页
                if (pageInfo.hasPreviousPage) {
                    var preLi = $("<li></li>").append($("<a></a>").append($("<span></span>").append("&laquo;")));
                    preLi.click(function () {
                        to_page(pageInfo.pageNum-1);
                    })
                }
                $("#page_nav").append(firstLi).append(preLi);

                $.each(pageInfo.navigatepageNums,function (index,items) {
                    var navLi = $("<li></li>").append($("<a></a>").append(items));
                    if (items == pageInfo.pageNum) {
                        navLi.addClass("active");
                    }
                    navLi.click(function () {
                        to_page(items);
                    })
                    $("#page_nav").append(navLi);
                })
                //下一页
                if (pageInfo.hasNextPage) {
                    var nextLi = $("<li></li>").append($("<a></a>").append($("<span></span>").append("&raquo;")));
                    nextLi.click(function () {
                        to_page(pageInfo.pageNum+1);
                    })
                }
                //尾页
                var lastLi = $("<li></li>").append($("<a></a>").append("尾页"));
                lastLi.click(function () {
                    to_page(pageInfo.pages);
                })
                $("#page_nav").append(nextLi).append(lastLi);
            }

            //表单重置方法
            function reset_form(ele) {
                $(ele)[0].reset();
                //清空表单样式
                $(ele).find("*").removeClass("has-error has-success");
                $(ele).find(".help-block").text("");
            }
            //新增按钮绑定单击事件(打开新增模态框)
            $("#add_model_btn").click(function (){
                //清除表单数据，不保存上次结果(表单完整重置)
                reset_form("#add_model form");

                $('#add_model').modal({
                    backdrop : false
                });
                getDepts("#add_model_select_dept");
            });
            //获取部门表所有数据
            function getDepts(ele) {
                //构建数据前先清空，防止分页里有多余数据
                $(ele).empty();
                $.ajax({
                    url:"${APP_PATH}/depts",
                    type:"get",
                    success:function (result) {
                        $.each(result.extend.depts,function (index,dept){
                            //也可以写参数用this代替
                            $(ele).append($("<option></option>")
                                .append(dept.deptName).attr("value",dept.deptId));
                        });
                    }
                });
            }
            //校验用户名是否可用
            $("#empName_add_input").change(function () {
                //发送ajax请求校验
                var empName = this.value;
                $.ajax({
                    url:"${APP_PATH}/checkUser",
                    data:"empName="+empName,
                    type:"POST",
                    success:function (result) {
                        if (result.code == 100) {
                            validate_status("#empName_add_input","success","用户名可用");
                            //用保存按钮的一个属性作为判断是否成功的依据
                            $("#emp_save_btn").attr("add_vali","success");
                        } else {
                            validate_status("#empName_add_input","error",result.extend.va_msg);
                            $("#emp_save_btn").attr("add_vali","error");
                        }
                    }
                })
            });
            //保存按钮绑定事件（添加员工）
            $("#emp_save_btn").click(function () {
                //1.前端校验，校验成功才会向后端发送请求
                if (!validate_add_form()) {
                    return false;
                }
                //2.后端校验，判断用户名是否可用
                if ($(this).attr("add_vali") == "error") {
                    return false;
                }
                //3.发送请求保存数据
                $.ajax({
                    url:"${APP_PATH}/emp",
                    data:$("#add_model_form").serialize(),
                    type:"POST",
                    success:function (result) {
                        //服务端传来的数据有两种可能
                        if (result.code == 100) {
                            //保存成功
                            //关闭模态框
                            $('#add_model').modal('toggle');
                            //来到最后一页，显示刚才保存的数据
                            to_page(totalRecord);
                        } else {
                            //如果错误域里存在某个属性，就调用添加校验状态信息的方法
                            if (undefined != result.extend.errorFiled.empName) {
                                validate_status("#empName_add_input","error","用户名可以是6-16位英文字母数字组合或2-5位中文");
                            }
                            if (undefined != result.extend.errorFiled.empEmail) {
                                validate_status("#email_add_input","error","请输入有效的邮箱地址")
                            }
                        }
                    }
                });
            })
            //正则表达式校验表单数据
            function validate_add_form() {
                //校验用户名
                var empName = $("#empName_add_input").val();
                var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
                if (!regName.test(empName)) {
                    validate_status("#empName_add_input","error","用户名可以是6-16位英文字母数字组合或2-5位中文");
                    return false;
                } else {
                    validate_status("#empName_add_input","success","")
                }
                //校验邮箱
                var empEmail = $("#email_add_input").val();
                var regEmail = /^[a-z\d]+(\.[a-z\d]+)*@([\da-z](-[\da-z])?)+(\.{1,2}[a-z]+)+$/;
                if (!regEmail.test(empEmail)) {
                    validate_status("#email_add_input","error","请输入有效的邮箱地址！")
                    return false;
                } else {
                    validate_status("#email_add_input","success","")
                }
                //默认return true
                return true;
            }
            //添加校验的状态信息
            function validate_status(ele,status,msg) {
                //清除当前元素校验状态
                $(ele).parent().removeClass("has-error has-success");
                $(ele).next("span").text("");
                if ("error" == status) {
                    $(ele).next("span").append(msg);
                    $(ele).parent().addClass("has-error");
                    return false;
                } else if ("success" == status){
                    $(ele).next("span").append(msg);
                    $(ele).parent().addClass("has-success");
                }
                return true;
            }
            //通过id查询员工信息
            function getEmp(id) {
                $.ajax({
                    url:"${APP_PATH}/emp/"+id,
                    type:"get",
                    success:function (result) {
                        var empData = result.extend.emp;
                        $("#empName_update_static").text(empData.empName);
                        $("#email_update_input").val(empData.empEmail);
                        $("#emp_update_model input[name=empGender]").val([empData.empGender]);
                        //把下拉列表，单选多选框的value值放入数组中即可选中
                        $("#emp_update_model select").val([empData.dId]);
                    }
                });
            }
            //编辑按钮绑定单击事件(打开编辑模态框)
            //因为按钮创建之前绑定了click，所以.click绑不上
            $(document).on("click",".edit_btn",function () {
                reset_form("#emp_update_model form");
                $("#emp_update_model").modal({
                    backdrop : false
                });
                //查出员工信息
                getEmp($(this).attr("editId"));
                //查出部门信息显示部门列表
                getDepts("#update_model_select_dept");
                //把员工的id传递给模态框的更新按钮
                $("#emp_update_btn").attr("edit_id",$(this).attr("editId"));

            });
            //为更新按钮绑定单击事件(更新员工数据)
            $("#emp_update_btn").click(function () {
                //验证邮箱是否合法
                //校验邮箱
                var empEmail = $("#email_update_input").val();
                var regEmail = /^[a-z\d]+(\.[a-z\d]+)*@([\da-z](-[\da-z])?)+(\.{1,2}[a-z]+)+$/;
                if (!regEmail.test(empEmail)) {
                    validate_status("#email_update_input","error","请输入有效的邮箱地址！");
                    return false;
                } else {
                    validate_status("#email_update_input","success","");
                }
                //发送ajax请求保存更新的员工数据
                $.ajax({
                   url:"${APP_PATH}/emp/"+$(this).attr("edit_id"),
                   type:"POST",
                   data:$("#update_model_form").serialize()+"&_method=PUT",
                   //  type:"PUT",
                   //  data:$("#update_model_form").serialize(),
                    success:function (result) {
                        //更新成功
                        //关闭模态框
                        $('#emp_update_model').modal('toggle');
                        to_page(currentPage);
                    }
                });
                //
            })
            //为删除按钮绑定单击事件(删除单个员工)
            $(document).on("click",".delete_btn",function (){
                //弹出确认删除框
                var empName = $(this).parents("tr").find("td:eq(2)").text();
                if (confirm("确认删除【"+empName+"】吗？")) {
                    $.ajax({
                        url:"${APP_PATH}/emp/"+$(this).attr("deleteId"),
                        type:"POST",
                        data:"_method=DELETE",
                        success:function (result) {
                            alert(result.msg);
                            //回到该页面
                            to_page(currentPage);
                        }
                    });
                }
            });
            //全选全不选
            /*
            * jQuery判断checked是否是选中状态的三种方法:
                .attr('checked') // 返回:"checked"或"undefined" ;
                .prop('checked') // 返回true/false
                .is(':checked')  // 返回true/false //别忘记冒号哦
            */
            $("#checkedAll").click(function () {
                //dom原生属性不要用attr获取，用prop获取
               //alert($(this).prop("checked"));
               $(".check_item").prop("checked",$(this).prop("checked"));
            });
            //子选框绑定单击事件，若全选中，总选框自动选中
            $(document).on("click",".check_item",function () {
               var flag = $(".check_item:checked").length == $(".check_item").length;
                $("#checkedAll").prop("checked",flag);
            });
            //全部删除按钮绑定单击事件
            $("#del_model_btn").click(function () {
                var empNames = "";
                var empIds = "";
                $.each($(".check_item:checked"),function () {
                     empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
                     empIds += $(this).parents("tr").find("td:eq(1)").text()+"-";
                });
                //去除多余的 ,
                empNames = empNames.substring(0,empNames.length-1);
                empIds = empIds.substring(0,empIds.length-1);
                if (confirm("确认删除【"+empNames+"】吗？")) {
                    $.ajax({
                        url:"${APP_PATH}/emp/"+empIds,
                        type:"POST",
                        data:"_method=DELETE",
                        success:function (result) {
                            alert(result.msg);
                            //回到该页面
                            to_page(currentPage);
                            $("#checkedAll").prop("checked",false);
                        }
                    });
                }
            });
        });
</script>
</head>
<body>
<%--员工更新模态框--%>
<div class="modal fade" id="emp_update_model" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">修改信息</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" id="update_model_form">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">姓名</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10">
                            <input name="empEmail" id="email_update_input" type="email" class="form-control" placeholder="aman@gmail.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <%--                  单选框性别--%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="empGender" value="M" checked> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="empGender" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <%--                    下拉列表部门--%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-4">
                            <%--                            部门提交部门id--%>
                            <select class="form-control" name="dId" id="update_model_select_dept">
                            </select>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>
<!-- 员工添加模态框-->
<div class="modal fade" id="add_model" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">新增员工</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" id="add_model_form">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">姓名</label>
                        <div class="col-sm-10">
                            <input name="empName" id="empName_add_input" type="text" class="form-control" placeholder="name">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10">
                            <input name="empEmail" id="email_add_input" type="email" class="form-control" placeholder="aman@gmail.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
<%--                  单选框性别--%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="empGender" value="M" checked> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="empGender" value="F"> 女
                            </label>
                        </div>
                    </div>
<%--                    下拉列表部门--%>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门</label>
                        <div class="col-sm-4">
<%--                            部门提交部门id--%>
                            <select class="form-control" name="dId" id="add_model_select_dept">

                            </select>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<%--搭建显示页面--%>
<div class="container">
    <%--标题--%>
    <div class="row">
        <div class="col-md-12"><h1>SSM_CRUD</h1></div>
    </div>
    <%--    按钮--%>
    <div class="row">
        <div class="col-md-2 col-md-offset-9">
            <button id="add_model_btn" class="btn btn-primary">新增</button>
            <button id="del_model_btn" class="btn btn-danger">删除</button>
        </div>
    </div>
    <%--    表格数据--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table" id="emps_table">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="checkedAll"/>
                    </th>
                    <th>#</th>
                    <th>empName</th>
                    <th>empGender</th>
                    <th>empEmail</th>
                    <th>department</th>
                    <th>Operation</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
    <%--    显示分页信息--%>
    <div class="row">
        <div class="col-md-6" id="page_info"></div>
        <div class="col-md-6">
            <nav aria-label="Page navigation">
                <ul class="pagination" id="page_nav">
                </ul>
            </nav>
        </div>
    </div>

</div>
</body>
</html>
