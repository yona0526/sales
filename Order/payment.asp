
<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include virtual="/include/dbopen.asp"-->
<%
Session.CodePage = 65001
Response.CharSet = "UTF-8"
%>
<%
strcon = "DRIVER=MySQL ODBC 3.51 Driver;SERVER=121.133.107.93;UID=root;PWD=citibank01;DATABASE=cmsdb;"
set cmsDB = Server.CreateObject("ADODB.Connection")
cmsDB.open strcon
cmsDB.execute("set names euckr")
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>명절특판</title>
    <meta name="viewport" content="initial-scale=1.0,user-scalable=no,maximum-scale=1,width=device-width" />
    <link rel="stylesheet" type="text/css" media="screen" href="../common/basic.css" />
    <link rel="stylesheet" type="text/css" media="screen" href="../common/layout.css" />
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
    input[type=number]::-webkit-outer-spin-button {  
    -webkit-appearance: "Always Show Up/Down Arrows";
    }
    </style>
</head>

<%
  product_id	= request("id")

strcon = "DRIVER=MySQL ODBC 3.51 Driver;SERVER=121.133.107.93;UID=root;PWD=citibank01;DATABASE=cmsdb;"
set myDB = Server.CreateObject("ADODB.Connection")
myDB.open strcon
myDB.execute("set names euckr")

  SQL = "select * from cms_products where _id = '" & product_id & "' "
  set rs = Server.CreateObject("ADODB.Recordset")
  Rs.Open SQL, myDB

  company_id		= rs("company_id")
  serial_no		= rs("serial_no")
  cat_main_name	= rs("cat_main_name")
  cat_sub_name		= rs("cat_sub_name")
  main_id			= rs("main_id")
  sub_id			= rs("sub_id")
  product_name		= rs("product_name")
  img_large		= rs("img_large")
  img_small		= rs("img_small")
  price_retail		= rs("price_retail")
  price_sale		= rs("price_sale")
  price_supply		= rs("price_supply")
  commision_rate	= rs("commision_rate")
  tax_free			= rs("tax_free")
  stock			= rs("stock")
  brand			= rs("brand")
  vendor			= rs("vendor")
  origin_country 	= rs("origin_country")
  description 		= rs("description")
  info_notice 		= rs("info_notice")
  delivery_class	= rs("delivery_class")
  delivery_fee		= rs("delivery_fee")
  delivery_discount = rs("delivery_discount")
  delivery_policy	= rs("delivery_policy")
  option_class		= rs("option_class")
  delivery_box      = rs("delivery_box")
  ' options			= rs("options")

  optionStr   = rs("options")
  options     = split(optionStr, "^")
  option1     = split(options(0), "@")
  option2     = split(options(1), "@")

   if IsNull(price_retail) then
      price_retail_dis   = 0
   else
      price_retail_dis = price_retail
   end if

   if IsNull(price_sale) then
      price_sale_dis   = 0
   Else
      price_sale_dis = price_sale
   end If

   if IsNull(delivery_fee) then
      delivery_fee_dis   = 0
   Else
      delivery_fee_dis = delivery_fee
   end If

   if IsNull(stock) then
      stock_dis   = 0
   Else
      stock_dis = stock
   end if

   Disrate = Round((price_retail_dis - price_sale_dis) /  price_retail_dis  * 100)


    supplier		= rs("supplier")


%>

<body>
<div id="speWrap" contextmenu="return false">
    <div id="header">
        <h1><a href="../index.asp">2022 추석 선물세트</a></h1>

        <div id="lnb">
            <a href="/Order/myorder.asp">나의 구매내역</a>
            <a href="/include/2022_gmidas_catalog_autumn.pdf">카탈로그 내려받기</a>
        </div>
        
    </div>
    <div id="contents">
        <div class="payDetail">
            <h3><%=product_name%></h3>
            <div class="pay_thumb">
                <img src="<%=img_large%>" alt="" />
                <input type="hidden" id="img_large" name="img_large" value="<%=img_large%>" >
            </div>
            <!--
            <dl class="deliver_dl">
              <dt>상품명</dt>
              <dd><%=product_name%></dd>
            </dl>-->
            <dl class="deliver_dl">
              <dt>구매자명</dt>
              <dd><input type="text" id="customer-name" name="customer-name"class="textLong" ></dd>
            </dl>
            <dl class="deliver_dl">
              <dt>구매자 연락처</dt>
              <dd><input type="text" id="customer-hp" name="customer-hp" class="textLong"></dd>
            </dl>
            <dl class="deliver_dl">
              <dt>수취인명</dt>
              <dd><input type="text" id="customer-Recname" name="customer-Recname"class="textLong" ></dd>
            </dl>
            <dl class="deliver_dl">
              <dt>수취인 연락처</dt>
              <dd><input type="text" id="customer-Rechp" name="customer-Rechp"  class="textLong"></dd>
            </dl>
            <dl class="deliver_dl">
              <dt style="vertical-align:top">배송주소</dt>
              <dd>
                <input type="text"  id="postCode" name="postCode" style="width:40%"  placeholder="우편번호" readonly>
                <button type="button" id="btn__postcard" class="input-btn" onClick="execDaumPostCode()">우편번호 찾기</button>
                <input type="text"  id="roadAddress"  placeholder="주소"readonly />
                <input type="text"   id="detailAddress"    placeholder="상세주소" />

                <div id="layer" style="display:none;position:fixed;overflow:hidden;z-index:1;-webkit-overflow-scrolling:touch;">
                <img src="//i1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1" onclick="closeDaumPostcode()" alt="닫기 버튼"></div>
              </dd>
            </dl>
            <dl class="deliver_dl">
              <dt>배송메모</dt>
              <dd><input type="text" id="shop_message" name="shop_message" class="textLong"></dd>
            </dl>
            <p class="bulk_notice">
              대량 구매 시 별도 배송 
              <span>문의전화 02-535-7395</span>
            </p>
          
            <dl class="price_dl">
                <% if options(0) <> "@" and ubound(option1) >= 1 then %>
                <dt>옵션1</dt>
                <dd>
                    <select id="selectType01" name="options">
                        <option value="">--옵션선택 -- </option>
                        <% for i=0 to ubound(option1) %>
                          <% if (i mod 2) = 0 then %>
                          <option value="<%= i %>" data-io-id="<%= option1(i) %>" data-io-price="<%= option1(i+1) %>" ><%= option1(i) %></option>
                          <% end if %>
                        <% next %>
                    </select>
                </dd>
                <% end if %>
                <% if options(1) <> "@" and ubound(option2) >= 1 then %>
                <dt>옵션2</dt>
                <dd>
                    <select id="selectType02" name="options" >
                        <option value="">--옵션선택 -- </option>
                        <% for i=0 to ubound(option1) %>
                          <% if (i mod 2) = 0 then %>
                          <option value="<%= i %>" data-io-id="<%= option2(i) %>" data-io-price="<%= option2(i+1) %>" ><%= option2(i) %></option>
                          <% end if %>
                        <% next %>
                    </select>
                </dd>
                 <% end if %>

                <dt>수량</dt>
                <dd><input type="number" id="amount"  min="1" max="<%=delivery_box%>" name="chk4" class="textshort">개</dd>

                <dt>상품금액</dt>
                <dd><%=formatnumber(price_sale,0,,,-1)%>원</dd>

                <dt>배송비</dt>
              <%if delivery_fee_dis = 0 then%>
                   <dd> 배송비 무료 </dd>
              <%else%>        
                <dd>  <%=formatnumber(delivery_fee_dis,0,,,-1)%> 원</dd>
              <%end if%>
                <dt>총 결제금액</dt>
                <dd><span id="price"></span></dd>
            </dl>
            <div class="btn_pay">
                <button onClick="doReserve()" >결제하기</button>
            </div>
        </div>
          <form action="pay_Confirm.asp" method="post" id="reserve-info"></form>
            <%if description <> "" then %>
        <div class="img_description"><%=description%></div>

    </div>
<%end if%>

</div>
    <div id="footer">
        © GMIDAS. All rights reserved.
    </div>
</body>
</html>

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
    // 우편번호 찾기 화면을 넣을 element
    var element_layer = document.getElementById('layer');

    function closeDaumPostcode() {
        // iframe을 넣은 element를 안보이게 한다.
        element_layer.style.display = 'none';
    }

    function execDaumPostCode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = data.address; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 기본 주소가 도로명 타입일때 조합한다.
                if(data.addressType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('postCode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('roadAddress').value = fullAddr;

                document.getElementById('detailAddress').focus();
                // iframe을 넣은 element를 안보이게 한다.
                // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
                element_layer.style.display = 'none';
            },
            width : '100%',
            height : '100%'
        }).embed(element_layer);

        // iframe을 넣은 element를 보이게 한다.
        element_layer.style.display = 'block';

        // iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
        initLayerPosition();
    }

    // 브라우저의 크기 변경에 따라 레이어를 가운데로 이동시키고자 하실때에는
    // resize이벤트나, orientationchange이벤트를 이용하여 값이 변경될때마다 아래 함수를 실행 시켜 주시거나,
    // 직접 element_layer의 top,left값을 수정해 주시면 됩니다.
    function initLayerPosition(){
        var width = 300; //우편번호 서비스가 들어갈 element의 width
        var height = 460; //우편번호 서비스가 들어갈 element의 height
        var borderWidth = 5; //샘플에서 사용하는 border의 두께

        // 위에서 선언한 값들을 실제 element에 넣는다.
        element_layer.style.width = width + 'px';
        element_layer.style.height = height + 'px';
        element_layer.style.border = borderWidth + 'px solid';
        // 실행되는 순간의 화면 너비와 높이 값을 가져와서 중앙에 뜰 수 있도록 위치를 계산한다.
        element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px';
        element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height)/2 - borderWidth) + 'px';
    }
</script>



<script>

let optPrice = 0
let price_total = 0


$("select[name=options]").change(function() {
  optPrice = $("option:selected").data("ioPrice")
})

// 수량
$("#amount").change(function () {
  if ($("select[name=options]").val() == "") {
      alert('옵션을 먼저 선택해주세요.');
      $(this).val(0)
      return false
  }
      

	//$("#purchase-count").html($(this).val() + "개")
     select_num = Number($(this).val())

	if ($(this).val() > 0) {
		price_total = ((<%=price_sale_dis%> + optPrice) * Number(select_num)) + <%=delivery_fee_dis%>
	} else {
		price_total = <%=price_sale_dis%> + optPrice + <%=delivery_fee_dis%>
	}
	$("#price").html(setNumAsCurrency(price_total)+"원")
})
</script>
<script>
function doReserve() {
	let pname     = "<%=product_name%>"
	let Hidx      = "<%=product_id%>"
    let supplier  = "<%=supplier%>"

	// 이용자 정보 및 가격
	let mname     = $("#customer-name").val()
	let mhp       = $("#customer-hp").val()
	let rname   = $("#customer-Recname").val()
	let rhp     = $("#customer-Rechp").val()
	let rpostno = $("#postCode").val()
	let raddr1  = $("#roadAddress").val()
	let raddr2   = $("#detailAddress").val()
    let price_sale = "<%=price_sale%>"
    let delivery_fee_dis = "<%=delivery_fee_dis%>"
    let img_large = $("#img_large").val()
	let purchasecount = $("#amount").val()
    let options2      =  $("#selectType02 option:selected").text()  
    let options1      = $("#selectType01 option:selected").text()
    
   if($("#amount").val() == '0'){
    alert("주문수량을 입력해주세요.")
		return false
   }

	let price = price_total

	if ((rname == "") || (rhp == "") || (rpostno == "") || (raddr1 == "") || (raddr2 == "")) {
		alert("주문 정보를 입력해주세요.")
		return false
	}

	 let Sendmsg = $("#shop_message").val()

	// 진행 확인
	let confirmReservation = confirm("주문하시겠습니까?");
	if (!confirmReservation) {
		alert("취소되었습니다.")
		return false
	}

	$('<input>', { type: 'hidden', id: 'pname', name: 'pname', value: pname                                }).appendTo("#reserve-info");
	$('<input>', { type: 'hidden', id: 'mname', name: 'mname', value: mname                                }).appendTo("#reserve-info");
	$('<input>', { type: 'hidden', id: 'mhp', name: 'mhp', value: mhp                                      }).appendTo("#reserve-info");
	// 이용자 정보 및 가격
	$('<input>', { type: 'hidden', id: 'rname', name: 'rname', value: rname                                }).appendTo("#reserve-info");
	$('<input>', { type: 'hidden', id: 'rhp', name: 'rhp', value: rhp                                      }).appendTo("#reserve-info");
	$('<input>', { type: 'hidden', id: 'rpostno', name: 'rpostno', value: rpostno                          }).appendTo("#reserve-info");
	$('<input>', { type: 'hidden', id: 'raddr1', name: 'raddr1', value: raddr1                             }).appendTo("#reserve-info");
	$('<input>', { type: 'hidden', id: 'raddr2', name: 'raddr2', value: raddr2                             }).appendTo("#reserve-info");
	$('<input>', { type: 'hidden', id: 'purchasecount', name: 'purchasecount', value: purchasecount     }).appendTo("#reserve-info");
	$('<input>', { type: 'hidden', id: 'price', name: 'price', value: price                                }).appendTo("#reserve-info");
	$('<input>', { type: 'hidden', id: 'Hidx', name: 'Hidx', value: Hidx                                   }).appendTo("#reserve-info");
    $('<input>', { type: 'hidden', id: 'supplier', name: 'supplier', value: supplier                       }).appendTo("#reserve-info");
    $('<input>', { type: 'hidden', id: 'pricesale', name: 'pricesale', value: price_sale                       }).appendTo("#reserve-info");
    $('<input>', { type: 'hidden', id: 'options2', name: 'options2', value: options2                       }).appendTo("#reserve-info");
    $('<input>', { type: 'hidden', id: 'options1', name: 'options1', value: options1                       }).appendTo("#reserve-info");
    $('<input>', { type: 'hidden', id: 'deliveryfeedis', name: 'deliveryfeedis', value: delivery_fee_dis  }).appendTo("#reserve-info");
	$('<input>', { type: 'hidden', id: 'Sendmsg',  name: 'Sendmsg',  value: Sendmsg                        }).appendTo("#reserve-info");
	$('<input>', { type: 'hidden', id: 'imglarge',  name: 'imglarge',  value: img_large                        }).appendTo("#reserve-info");
	$("#reserve-info").submit()
}
</script>

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
     <script>
    Date.prototype.toStringYMD = function() {
        var mm = this.getMonth() + 1
        var dd = this.getDate()

        return [this.getFullYear(), (mm>9 ? '' : '0') + mm, (dd>9 ? '' : '0') + dd].join('-')
    };
    Number.prototype.AddLeadingZero = function(size) {
        var s = String(this);
        while (s.length < (size || 2)) {s = "0" + s;}
        return s;
    }
    function setNumAsCurrency(x) {
        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
 
  </script>
   <script> 
$(document).ready(function(){
 $(document).bind("contextmenu", function(e) {
  return false;
 });
});
$(document).bind('selectstart',function() {return false;}); 
$(document).bind('dragstart',function(){return false;}); 
</script>