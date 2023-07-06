
<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include virtual="/include/dbopen.asp"-->
<%
Session.CodePage = 65001
Response.CharSet = "UTF-8"
%>

<%
orderName    =  request.form("orderName")
orderPhone   =  request.form("orderPhone")
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>명절특판</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" type="text/css" media="screen" href="../common/basic.css" />
    <link rel="stylesheet" type="text/css" media="screen" href="../common/layout.css" />
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script>
     function count(type) {
            // 결과를 표시할 element
            const resultElement = document.getElementById('orderAmount');

            // 현재 화면에 표시된 값
            let number = resultElement.innerText;

            // 더하기/빼기
            if (type === 'plus') {
                number = parseInt(number) + 1;
            } else if (type === 'minus') {
                number = parseInt(number) - 1;
            }

            // 결과 출력
            resultElement.innerText = number;
        }
    </script>
    <style>
        html,body {height:100%}
      
    </style>
</head>
<body>
<div id="speWrap">
    <div id="header">
        <h1><a href="../index.asp">2022 추석 선물세트</a></h1>

        <div id="lnb">
            <a href="/order/myorder.asp">나의 구매내역</a>
            <a href="/include/2022_gmidas_catalog_autumn.pdf">카탈로그 내려받기</a>
        </div>
      
    </div>
    <div id="contents">
        <div class='orderer'>
            <table>
                <colgroup>
                    <col style="width:25%" />
                    <col style="width:79%" />
                    
                </colgroup>
                <form id="writeForm4" name="writeForm4" method="Post" >
                <tr>
                    <th>성명</th>
                    <td>
                        <input type="text" id="orderName" name="orderName">
                    </td>
                    
                </tr>
                <tr>
                    <th>연락처</th>
                    <td>
                        <input type="text" id="orderPhone" name="orderPhone">
                    </td>
                    <tr>
                    <td colspan="2" style="text-align:center;">
                        <button id="btn_orderView">조회</button>
                    </td>
                    </tr>
                </tr>
                </form>
            </table>
        </div>
        <table class="myOrder">
<%
SQL = "SELECT Amt,BuyerName,GoodsName,i_count,dbo.ecl_decrypt(BuyerHp) as BuyerHp,ReciverName,dbo.ecl_decrypt(ReciverHP) as ReciverHP, ReciverAddr1,"
SQL = SQL& " ReciverAddr2,ReciverPostNo,convert(varchar(10), RegDate, 120) as RegDate , UserMsg, Pmemo, STATUS_GUBUN FROM NEWMIDAS.DBO.TBL_PG_ORDER_SMARTRO_RESULT WHERE VMID = 'GMRESORT7M' "
SQL = SQL& " AND BUYERNAME='"&orderName&"' AND BuyerHp = DBO.ECL_ENCRYPT('"&orderPhone&"') " 

SET RS = DB.EXECUTE(SQL)
if RS.eof then
%>
            <tr>
                <th>주문일</th>
                <th>상품명/선택옵션</th>
                <th>수량</th>
                <th>결제금액</th>
                <th>주문상태</th>
            </tr>
            <tr>
                 <td colspan="5">구매 내역이 없습니다.</td>
            </tr>
<%
else

do until rs.eof  
Amt            =     RS("Amt")
BuyerName      =     RS("BuyerName")
GoodsName      =     RS("GoodsName")
i_count        =     RS("i_count")
BuyerHp        =     RS("BuyerHp")
ReciverName    =     RS("ReciverName")
ReciverHP      =     RS("ReciverHP")
ReciverAddr1   =     RS("ReciverAddr1")
ReciverAddr2   =     RS("ReciverAddr2")
ReciverPostNo  =     RS("ReciverPostNo")
RegDate        =     RS("RegDate")
UserMsg        =     RS("UserMsg")
Pmemo          =     RS("Pmemo")
STATUS_GUBUN   =     RS("STATUS_GUBUN")

if Pmemo = "" then
RePmemo = " "
else
RePmemo         =     RS("Pmemo")
end if

IF STATUS_GUBUN = "P" or  STATUS_GUBUN = "0" THEN
STATUS_GUBUN = "결제완료"
ELSEIF STATUS_GUBUN = "M" or  STATUS_GUBUN = "5" or  STATUS_GUBUN = "3" THEN
STATUS_GUBUN = "취소완료"
END IF




ReciverAddr    =  ReciverPostNo&"/"&ReciverAddr1&"-"&ReciverAddr2
%>
            <tr>
                <th>주문일</th>
                <th>상품명/선택옵션</th>
                <th>수량</th>
                <th>결제금액</th>
                <th>주문상태</th>
            </tr>
            <tr>
                <td><%=RegDate%></td>
                <td><%=GoodsName%></td>
                <td><%=i_count%></td>
                <td><%=Amt%></td>
                <td><%=STATUS_GUBUN%></td>
            </tr>
            <tr>
                <td colspan="5">
                <dl class="shipment_dl">
                    <dt>배송지</dt>
                        <dd><%=ReciverAddr%></dd>
                    <dt>수령인</dt>
                        <dd><%=ReciverName%></dd>
                    <dt>수령연락처</dt>
                        <dd><%=ReciverHP%></dd>
                    <dt>주문요청사항</dt>
                        <dd><%=UserMsg%></dd>
                    
                    <%if RePmemo = " " then%>
                     <dt>운송장번호</dt>
                        <dd>준비 중</dd> 
                    <%else%>
                    <dt>운송장번호</dt>
                        <dd><%=Pmemo%></dd> 
                    <%end if%>  
                </dl>
                </td>
            </tr>

<%
rs.movenext
loop

end if
%>



        </table>
        
    </div>
    <div id="footer">
        © GMIDAS. All rights reserved.
    </div>
</div>

</body>
</html>

<script>

$('#btn_orderView').click(function() {

            if ($("#orderName").val() == "") {
                alert('이름을 입력해주세요');
                $("#orderName").focus();
                return;
            }
            if ($("#orderPhone").val() == "") {
                alert('전화번호를 입력해주세요');
                $("#orderPhone").focus();
                return;
            }
    $("#writeForm4").submit()
});
</script>
