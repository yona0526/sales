<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>명절특판</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" type="text/css" media="screen" href="../common/basic.css" />
    <link rel="stylesheet" type="text/css" media="screen" href="../common/layout.css" />
    <script src="main.js"></script>
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
</head>
<body>
<div id="speWrap">
    <div id="header">
        <h1><a href="../index.asp">2022 추석 선물세트</a></h1>

        <div id="lnb">
            <a href="myorder.asp">나의 구매내역</a>
            <a href="/include/2022_gmidas_catalog_autumn.pdf">카탈로그 내려받기</a>
        </div>
       
    </div>
    <div id="contents">
      <div class="completeWrap">
        <div class="comeplete_tit">
            주문 내역 및 배송 현황은 <a href="myorder.asp">나의 구매내역</a>에서 확인 가능합니다.
        </div>

      </div>
        
    </div>
    <div id="footer">
        © GMIDAS. All rights reserved.
    </div>
</div>

</body>
</html>



<script language='javascript'>
function noEvent() {
	if(event.keyCode == 116) {
		event.keyCode= 2;
		return false;
	} else if((event.ctrlKey && (event.keyCode==78 || event.keyCode == 82)) || (event.altKey && (event.keyCode==37))) {
		return false;
	}
}
document.onkeydown = noEvent;

history.pushState(null, null, location.href);
window.onpopstate = function(event) {
	history.go(1);
};
</script>
