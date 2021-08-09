<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: wen xuan
  Date: 2021/8/7
  Time: 18:20
  To change this template use File | Settings | File Templates.
--%>
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
</head>
<body>
<%--搭建显示页面--%>
<div class="container">
<%--标题--%>
    <div class="row">
        <div class="col-md-12"><h1>SSM_CRUD</h1></div>
    </div>
<%--    按钮--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary">新增</button>
            <button class="btn btn-danger">删除</button>
        </div>
    </div>
<%--    表格数据--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table">
                <tr>
                    <th>#</th>
                    <th>empName</th>
                    <th>empGender</th>
                    <th>empEmail</th>
                    <th>department</th>
                    <th>Operation</th>
                </tr>
                <c:forEach items="${pageInfo.list}" var="emp">
                    <tr>
                        <th>${emp.empId}</th>
                        <th>${emp.empName}</th>
                        <th>${emp.empGender}</th>
                        <th>${emp.empEmail}</th>
                        <th>${emp.department.deptName}</th>
                        <th>
                            <button class="btn btn-primary btn-sm">
                                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                编辑
                            </button>
                            <button class="btn btn-danger btn-sm">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                                删除
                            </button>
                        </th>
                    </tr>
                </c:forEach>

            </table>
        </div>
    </div>
<%--    显示分页信息--%>
    <div class="row">
        <div class="col-md-6">当前第${pageInfo.pageNum}页,共${pageInfo.pages}页,共有${pageInfo.total}条记录</div>
        <div class="col-md-6">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li><a href="${APP_PATH}/emps?pn=1">首页</a></li>
<%--                    有上一页才会显示符号--%>
                    <c:if test="${pageInfo.hasPreviousPage == true}">
                        <li>
                            <a href="${APP_PATH}/emps?pn=${pageInfo.prePage}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>
<%--                    遍历所有导航页号--%>
                    <c:forEach items="${pageInfo.navigatepageNums}" var="page_Num">
                        <c:if test="${page_Num == pageInfo.pageNum}">
                           <li class="active"><a href="#">${page_Num}</a></li>
                         </c:if>
                        <c:if test="${page_Num != pageInfo.pageNum}">
                            <li><a href="${APP_PATH}/emps?pn=${page_Num}">${page_Num}</a></li>
                        </c:if>
                    </c:forEach>

                    <c:if test="${pageInfo.hasNextPage == true}">
                        <li>
                            <a href="${APP_PATH}/emps?pn=${pageInfo.nextPage}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <li><a href="${APP_PATH}/emps?pn=${pageInfo.pages}">尾页</a></li>
                </ul>
            </nav>
        </div>
    </div>

</div>
</body>
</html>
