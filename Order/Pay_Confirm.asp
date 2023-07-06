<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include virtual="/include/dbopen.asp"-->
<!--#include file="base64.asp"-->
<!--#include file="sha256.asp"-->
<!--#include file="md5.asp"-->

<%
function getNow()
    dim aDate(2), aTime(2)

    aDate(0) = Year(Now)
    aDate(1) = Right("0" & Month(Now), 2)
    aDate(2) = Right("0" & Day(Now), 2)

    aTime(0) = Right("0" & Hour(Now), 2)
    aTime(1) = Right("0" & Minute(Now), 2)
    aTime(2) = Right("0" & Second(Now), 2)

    ' getNow = aDate(0)&aDate(1)&aDate(2)&aTime(0)&aTime(1)&aTime(2)
    getNow = aDate(0)&aDate(1)&aDate(2)&aTime(0)&aTime(1)
end function
%>

<%
Session.CodePage = 65001
Response.CharSet = "UTF-8"
pname          =  request.form("pname")
mname          =  request.form("mname")
mhp            =  request.form("mhp")
rname          =  request.form("rname")
rhp            =  request.form("rhp")
rpostno        =  request.form("rpostno")
raddr1         =  request.form("raddr1")
raddr2         =  request.form("raddr2")
purchasecount  =  request.form("purchasecount")
price          =  request.form("price")
Hidx           =  request.form("Hidx")
supplier       =  request.form("supplier")
Sendmsg        =  request.form("Sendmsg")
pricesale      =  request.form("pricesale")
deliveryfeedis =  request.form("deliveryfeedis")
imglarge       =  request.form("imglarge")
options2       =  request.form("options2")
options1       =  request.form("options1")
address        =  raddr1&"-"&raddr2
options        =  options1&"-"&options2
'결제관련
'=====================================================================================================================
' 유니크한 Oreder 번호 만들기
'=====================================================================================================================
req_time         = datepart("d", Now) & datepart("h", Now) & datepart("n", Now) & datepart("s", Now) '//일시분
rnd_serial       = RIGHT(rhp, 4)
OrderCode        = req_time & rnd_serial
'response.write OrderCode
Connect_Gubun		= "W"
Category_name		= "명절선물세트"
Product_Qty			= 1
'=========================  Tcart  insert
SQL = "INSERT INTO TBL_JULMALL_TCART(MCONN_GUBUN,ORDERCODE, MASTERIDKEY,MEMBERNAME,MEMBERHP,MEMBERPOSTNO,MEMBERADDR1,MEMBERADDR2,REVNAME, REVHP,REVPOSTNO,REVADDR1,REVADDR2,   "
SQL = SQL & " CATEB_NAME,PRODUCT_NAME, PRODUCT_KEY,PRODUCT_SUBKEY,PRODUCT_PRICE, PRODUCT_QTY,USE_PRODUCT_KEY,USE_SREVDATE,USE_EREVDATE,USE_PY,USE_WEEKCOUNT,"
SQL = SQL & " USE_WEEKENDCOUNT, USE_OPTION, USE_MSG, SUPPLIER) "
SQL = SQL & " VALUES ("
SQL = SQL & " '"&CONNECT_GUBUN&"', "
SQL = SQL & " '"&ORDERCODE&"', "
SQL = SQL & " '"&MKEY&"', "
SQL = SQL & " '"&MNAME&"', "
SQL = SQL & " DBO.ECL_ENCRYPT('"&MHP&"'), "
SQL = SQL & " '"&MPOSTNO&"',"
SQL = SQL & " '"&MADDR1&"',"
SQL = SQL & " '"&MADDR2&"',"
SQL = SQL & " '"&RNAME&"',"
SQL = SQL & " DBO.ECL_ENCRYPT('"&RHP&"'), "
SQL = SQL & " '"&RPOSTNO&"', "
SQL = SQL & " '"&RADDR1&"', "
SQL = SQL & " '"&RADDR2&"', "
SQL = SQL & " '"&CATEGORY_NAME&"', "
SQL = SQL & " '"&PNAME&"', "
SQL = SQL & " '"&HIDX&"', "
SQL = SQL & " '"&HIDX&"', "
SQL = SQL & " '"&PRICE&"', "
SQL = SQL & " '"&PURCHASECOUNT&"', "
SQL = SQL & " '"&USED_TICKET_PIDX&"', "
SQL = SQL & " '"&CHECKINS&"', "
SQL = SQL & " '"&CHECKINE&"', "
SQL = SQL & " '"&ROOM_PY&"', "
SQL = SQL & " '"&COUPON_WEEK&"', "
SQL = SQL & " '"&COUPON_WEEKEND&"', "
SQL = SQL & " '"&OPTIONS&"', "
SQL = SQL & " '"&SENDMSG&"' , "
SQL = SQL & " '"&SUPPLIER&"' "
SQL = SQL & ") "
' RESPONSE.WRITE SQL
SET RS = DB.EXECUTE(SQL)


' 결제용 인자 준비

DEV_PAY_PC_ACTION_URL = "https://tpay.smilepay.co.kr/interfaceURL.jsp"	'개발
PRD_PAY_PC_ACTION_URL = "https://pay.smilepay.co.kr/interfaceURL.jsp"	'운영

DEV_PAY_MOBILE_ACTION_URL = "https://tspay.smilepay.co.kr/pay/interfaceURL"	'개발
PRD_PAY_MOBILE_ACTION_URL = "https://smpay.smilepay.co.kr/pay/interfaceURL"	'운영

RequestType = "PC"
' RequestType = "MOBILE"
encodingSET = "euc-kr"

sUsrAgent = UCase(Request.ServerVariables("HTTP_USER_AGENT"))

If InStr(sUsrAgent, "ANDROID") > 0 Then
	RequestType = "MOBILE"
    encodingSET = "utf-8"
ElseIf InStr(sUsrAgent, "IPAD") Or InStr(sUsrAgent, "IPHONE") Then
	RequestType = "MOBILE"
    encodingSET = "utf-8"
Else
	RequestType = "PC"
    encodingSET = "euc-kr"
End If

Select Case RequestType
    ' Case "PC": actionUrl = DEV_PAY_PC_ACTION_URL '개발 서버 URL
    ' Case "MOB": actionUrl = DEV_PAY_MOBILE_ACTION_URL '개발 서버 URL
    Case "PC": actionUrl = PRD_PAY_PC_ACTION_URL '운영 서버 URL
    Case "MOBILE": actionUrl = PRD_PAY_MOBILE_ACTION_URL '운영 서버 URL
End Select

' merchantID    = "SMTPAY001m"
' merchantKEY   = "0/4GFsSd7ERVRGX9WHOzJ96GyeMTwvIaKSWUCKmN3fDklNRGw3CualCFoMPZaS99YiFGOuwtzTkrLo4bR4V+Ow=="

merchantID    = "gmresort7m"
merchantKEY   = "eLh2BJwdRTIDihmi7YozA0ZsZFQTHZICOIXcrpQmuaDccPvicurE+PlR3NIQ0cM7+x6QXyCzJwfcI+KgGOJrKg=="
returnURL     = "http://spe.julgigo.com/SPayment/returnPay.asp"
mallUserID    = "JULGIGO"

ediDate       = getNow() '전문생성일시
PRODUCT_PRICE = pricesale
GOODSAMT      = price
' encryptDATA   = base64Encode(MD5(ediDate + merchantID + GOODSAMT + merchantKEY))
encryptDATA   = HASH("sha256",ediDate & merchantID & GOODSAMT & merchantKEY)
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
    // function count(type) {
    //     // 결과를 표시할 element
    //     const resultElement = document.getElementById('orderAmount');

    //     // 현재 화면에 표시된 값
    //     let number = resultElement.innerText;

    //     // 더하기/빼기
    //     if (type === 'plus') {
    //         number = parseInt(number) + 1;
    //     } else if (type === 'minus') {
    //         number = parseInt(number) - 1;
    //     }

    //     // 결과 출력
    //     resultElement.innerText = number;
    // }
</script>
</head>

<body>
<div id="speWrap" contextmenu="return false">
    <div id="header">
        <h1><a href="../index.asp">2022 추석선물세트</a></h1>

        <div id="lnb">
            <a href="/order/myorder.asp">나의 구매내역</a>
            <a href="/include/2022_gmidas_catalog_autumn.pdf">카탈로그 내려받기</a>
        </div>
    </div>
    <div id="contents">
        <div class="payDetail">
            <h3>상품정보 확인 - 결제</h3>
            <div class="pay_thumb">
                <img src="<%=imglarge%>" alt="" />
            </div>

            <dl class="deliver_dl">
                <dt>상품명</dt>
                <dd><%=pname%></dd>

                <dt>구매자명</dt>
                <dd><%=mname%></dd>

                <dt>구매자 연락처</dt>
                <dd><%=mhp%></dd>

                <dt>수취인명</dt>
                <dd><%=rname%></dd>

                <dt>수취인 연락처</dt>
                <dd><%=rhp%></dd>

                <dt>배송주소</dt>
                <dd><%=address%></dd>

                <dt>배송메모</dt>
                <dd><%=Sendmsg%></dd>
            </dl>
            <dl class="price_dl">
                <dt>수량</dt>
                <dd>
                    <%=purchasecount%>개
                </dd>

                <dt>상품금액</dt>
                <dd><%=formatnumber(pricesale,0,,,-1)%>원</dd>

                <dt>배송비</dt>
                <dd><%=formatnumber(deliveryfeedis,0,,,-1)%>원</dd>

                <dt>총 결제금액</dt>
                <dd><%=formatnumber(price,0,,,-1)%>원</dd>
            </dl>

            <!--
            결제수단 참고용
            <select name="PayMethod" class="selectbox">
                <option value="">[선택]</option>
                <option value="CARD" selected="">CARD-[신용카드]</option>
                <option value="BANK">BANK-[계좌이체]</option>
                <option value="VBANK">VBANK-[가상계좌]</option>
                <option value="CELLPHONE">CELLPHONE-[휴대폰결제]</option>
                <option value="KAKAO">KAKAO-[카카오]</option>
                <option value="NAVER">NAVER-[네이버]</option>
            </select>
            -->

            <div class="btn_pay">
                <form name="tranMgr" method="post" action="" accept-charset="<%=encodingSET%>">
                    <input type="hidden" name="PayMethod"     value="CARD"/>

                    <!-- <input type="hidden" name="MallUserID"    value="<%=mallUserID %>"/>-->
                    <input type="hidden" name="MID"           value="<%=merchantID %>"/>
                    <input type="hidden" name="ReturnURL"     value="<%=returnURL %>"/>
                    <input type="hidden" name="RetryURL"      value="http://spe.julgigo.com" />
                    <input type="hidden" name="StopURL"       value="http://spe.julgigo.com" />
                    <input type="hidden" name="DivideInfo"    value="" />

                    <input type="hidden" name="Moid"          value="<%=OrderCode%>"/>
                    <input type="hidden" name="GoodsName"     value="<%=pname %>"/>
                    <input type="hidden" name="GoodsCnt"      value="<%=purchasecount %>"/>
                    <input type="hidden" name="Amt"           value="<%=price %>"/>

                    <input type="hidden"  name="BuyerName"    value="<%=mname %>" />
                    <input type="hidden"  name="BuyerTel"     value="<%=mhp %>" />
                    <input type="hidden"  name="BuyerEmail"   value="noname@smartro.co.kr" />
                    <input type="hidden"  name="BuyerPostNo"  value="<%=rpostno%>" />
                    <input type="hidden"  name="BuyerAddr"    value="<%=address %>" />

                    <input type="hidden"  name="UserIP"       value="<%=Request.ServerVariables("REMOTE_ADDR")%>" />
                    <input type="hidden"  name="MallIP"       value="<%=Request.ServerVariables("LOCAL_ADDR") %>" />

                    <input type="hidden" name="EncryptData"   value="<%=encryptDATA %>" />
                    <input type="hidden" name="MallResultFWD" value="Y" />
                    <input type="hidden" name="ediDate"	      value="<%=ediDate %>" />
                    <input type="hidden" name="FORWARD"       value="Y" />

                    <button id="order" onclick="goPay()"> 결제하기 </button>
                </form>
             <!--   <%=ediDate %> <br />
                <%=merchantID %> <br />
                <%=GOODSAMT %> <br />
                <%=merchantKEY %> <br /> -->
            </div>
        </div>
    </div>

<script type="text/javascript">
    function isMobile(){
        var UserAgent = navigator.userAgent;
        if (UserAgent.match(/iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson/i) != null || UserAgent.match(/LG|SAMSUNG|Samsung/) != null)
        {
            return true;
        } else {
            return false;
        }
    }
</script>

<script>

//  $("#order").click(function(){
//  let orderno     = "<%=OrderCode%>"
//  if(isMobile()){

//     alert ("PC에서만 결제가 가능합니다");
//     //window.open('/SPayment/pay_orderMobile.asp?orderno'+orderno, '', 'width=300, height=300');
//     //$('<input>', { type: 'hidden', id: 'ordercode', name: 'ordercode',  value: orderno }).appendTo("#reserve-mobile");
//     // $("#reserve-mobile").submit()

// }else{

//     $('<input>', { type: 'hidden', id: 'ordercode', name: 'ordercode',  value: orderno }).appendTo("#reserve-info");
// 	$("#reserve-info").submit()
// }

// });
</script>

    <div id="footer">
            © GMIDAS. All rights reserved.
    </div>
</div>

</body>


<script type="text/javascript">
	var encodingType = "EUC-KR";//EUC-KR

	function setAcceptCharset(form) {
		var browser = getVersionOfIE();
	    if(browser != 'N/A')
	    	document.charset = encodingType;//ie
	    else
	    	form.charset = encodingType;//else
	}

	function getVersionOfIE() {
		 var word;
		 var version = "N/A";

		 var agent = navigator.userAgent.toLowerCase();
		 var name = navigator.appName;

		 // IE old version ( IE 10 or Lower )
		 if ( name == "Microsoft Internet Explorer" ) {
			 word = "msie ";
		 } else {
			 // IE 11
			 if ( agent.search("trident") > -1 ) word = "trident/.*rv:";

			 // IE 12  ( Microsoft Edge )
			 else if ( agent.search("edge/") > -1 ) word = "edge/";
		 }

		 var reg = new RegExp( word + "([0-9]{1,})(\\.{0,}[0-9]{0,1})" );

		 if ( reg.exec( agent ) != null  )
			 version = RegExp.$1 + RegExp.$2;

		 return version;
	}

	function goPay() {
		var form = document.tranMgr;
		form.action = '<%=actionUrl%>';

       //alert(form.action)

		setAcceptCharset(form);

		// form.GoodsName.value = "<%=GoodsName%>";
		// form.BuyerName.value = "<%=BuyerName%>";
		// form.BuyerAddr.value = "<%=BuyerAddr%>";
		// form.EncryptData.value = "<%=EncryptData%>";
		// form.DivideInfo.value = "<%=DivideInfo%>";


		if ("<%=RequestType%>" == "PC") {
			if(form.FORWARD.value == 'Y') // 화면처리방식 Y(권장):상점페이지 팝업호출
			{
				var popupX = (window.screen.width / 2) - (545 / 2);
				var popupY = (window.screen.height /2) - (573 / 2);

				var winopts= "width=545,height=573,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=no,left="+ popupX + ", top="+ popupY + ", screenX="+ popupX + ", screenY= "+ popupY;
				var win =  window.open("", "payWindow", winopts);

				try{
					if(win == null || win.closed || typeof win.closed == 'undefined' || win.screenLeft == 0) {
						alert('브라우저 팝업이 차단으로 설정되었습니다.\n 팝업 차단 해제를 설정해 주시기 바랍니다.');
						return false;
					}
				}catch(e){}

				form.target = "payWindow";//payWindow  고정
				form.submit();
			}
			else // 화면처리방식 N:결제모듈내부 팝업호출
			{
				form.target = "payFrame";//payFrame  고정
				form.submit();
			}
		}
		else if ("<%=RequestType%>" == "MOB") {
			form.submit();
		}
		return false;
	}
</script>

</html>

<script>
    $(document).ready(function(){
        $(document).bind("contextmenu", function(e) {
            return false;
        });
    });
    $(document).bind('selectstart',function() {return false;});
    $(document).bind('dragstart',function(){return false;});
</script>