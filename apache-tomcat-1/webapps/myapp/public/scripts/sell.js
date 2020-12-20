const searchForm = document.getElementById('search-form');
const urlParams = new URLSearchParams(window.location.search);
const userNameVal = Cookies.get('username');

function checkSellData() {
    let inputs = $('.upload-form').children('input:not([type=file])');
    let date = $('#date').val();
    let time = $('#time').val();
    let isBidding = $('#bid').is(":checked") ? true : false;
    let price = $('#price').val();
    let phone = $('#phone').val();

    // check phone number validity.
    let phoneNum = true;
    let nums = phone.split('-');
    for (num of nums) {
        if(isNaN(num)) phoneNum = false;
    }

    // check for blank input
    let isBlank = false;
    inputs.each((index, item)=>{
        let inpVal = item.value;
        if(inpVal == undefined || inpVal == null || inpVal == '')
            isBlank = true;
    });

    // check for time validity
    let curTime = new Date();
    let bidTime = Date.parse(date + ' ' + time);
    
    if (isBlank)
        alert('Please fill in all form data');
    else if(bidTime < curTime)
        alert('Set end time later than current time');
    else if (isBidding === false && price == 0)
        alert('Set your price over 0 unless bid enabled');
    else if (!phoneNum)
        alert('Type in only number in phone');
    else if (phone.length > 13)
        alert('Too long number in phone');
    else if (nums.length != 3)
        alert("Type '-' between phone numbers");
    else if (isNaN(price))
        alert('Type number in price');
    else
        $('.upload-form')[0].submit();
}
function sendForm() {
    searchForm.submit();
}
function uploadFile(e){
    $('#upload-img').trigger('click');
}
function logout() {
    Cookies.remove('username', {path:'/', domain:'localhost'});
    window.location.reload();
}
function getFile(){
    const input = $('#upload-img').prop('files')[0];
    if (input) {
        var reader = new FileReader();
        reader.onload = ()=>{
            $('#preview').attr('src', reader.result);
        };
        reader.readAsDataURL(input);
    }
}

function loadProduct() {
   //get brief infos from server.
   $.ajax({
        url: 'http://localhost:8080/myapp/server/getmodify.jsp',
        data: { prdId: urlParams.get('prdId') },
        method: 'GET',
        dataType: 'json',
    }).done((json)=> {
        const time = new Date(json.endTime);
        let yyyy = time.getFullYear();
        let MM = time.getMonth() + 1;
        MM = MM < 10 ? '0' + MM : MM;
        let dd = time.getDate();
        dd = dd < 10 ? '0' + dd : dd;
        let hh = time.getHours();
        hh = hh < 10 ? '0' + hh : hh;
        let mm = time.getMinutes();
        mm = mm < 10 ? '0' + mm : mm;
        let ss = time.getSeconds();
        ss = ss < 10 ? '0' + ss : ss;
        const bidDate = `${yyyy}-${MM}-${dd}`;
        const bidTime = `${hh}:${mm}:${ss}`;

        $('#preview').attr('src', 'data:image/jpg;base64, ' + json.img);
        $('#title').val(json.prdName);
        $('#bid').attr('checked', true);
        $('#price').val(parseInt(json.curPrice));
        $('#date').val(bidDate);
        $('#time').val(bidTime);
        $('#place').val(json.place);
        $('#phone').val(json.phone);
        $('#article').val(json.article);
    })
    .fail((jqXHR, textStatus, errorThrown)=> {
        console.log(errorThrown);
    });
}
function Search() {
    $('#search-form')[0].submit();
}
function logout() {
    Cookies.remove('username', {path:'/', domain:'localhost'});
    window.location.reload();
}
function showOption(e) {
    if($(this).closest('#search-form').length) 
        $('#search-option').css('visibility', 'visible');
    else 
        $('#search-option').css('visibility', 'hidden');
    e.stopPropagation();
}

//if cookie is not set, return to home.
if(userNameVal == undefined || userNameVal == null) {
    alert('Please log-in first');
    window.location.href = 'http://localhost:8080/myapp/index.html';
}
else {
    $('#auth').children().remove();
    $('#auth').append('<li><a href="profile.html">Welcome! '+userNameVal+'</a></li>');
    $('#auth').append('<li><a id="logout" href="../../index.html">logout</a></li>');
    $('#logout').click(logout);
    $('#username').val(userNameVal);

    //check that the request is sent correctly.
    let success = urlParams.get('isSuccess');
    if(success == false) {
        alert('Please write down every form.');
    } else if(success == true) {
        alert('Product enrollment successed');
    }
    $("#preview").click(uploadFile);
    $('#upload-img').on('change', getFile);
    
    // use sell form for modification.
    if(urlParams.get('modify') == 'true'){
        $('.upload-form').attr('action', '../../server/setmodify.jsp');
        $('#prdId').val(urlParams.get('prdId'));
        loadProduct();
        $('#submit-btn').text('Modify');
    }
    else {
        $('#prdId').val(-1);
    }
    $('#submit-btn').click(checkSellData);
}
$('html *').click(showOption);
$('#search-btn *').click(Search);

//if cookie is not set, remove login and register button.
if( !(userNameVal == undefined || userNameVal == null) ) {
    $('#auth').children().remove();
    $('#auth').append('<li><a href="profile.html">Welcome! '+userNameVal+'</a></li>');
    $('#auth').append('<li><a id="logout" href="../../index.html">logout</a></li>');
    $('#logout').click(logout);
}