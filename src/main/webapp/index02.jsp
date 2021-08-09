<%--
  Created by IntelliJ IDEA.
  User: wen xuan
  Date: 2021/8/6
  Time: 13:32
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
    <script src="static/js/jquery-3.6.0.min.js"></script>
    <%--   import bootstrap--%>
    <link rel="stylesheet" href="static/bootstrap-3.4.1-dist/css/bootstrap.min.css">
    <script src="static/bootstrap-3.4.1-dist/js/bootstrap.min.js"></script>
</head>
<body>
<%--<jsp:forward page="/emps"/>--%>
<form action="${APP_PATH}/emp?empName=123" method="post">
    <input type="submit">
</form>
</body>
</html>
