const searchForm = $('#search-form');
const searchBar = $('#search-bar');
const urlParams = new URLSearchParams(window.location.search);
searchBar.value = urlParams.get('search-bar');
const userNameVal = Cookies.get('username');
let prdId = urlParams.get('id');
let b_wish = false;

function sendForm() {
    searchForm.submit();
};
function showTime(endTime) {
    let diff = Date.parse(endTime) - Date.now();
    let msec = diff;
    let hh = Math.floor(msec / 1000 / 60 / 60);
    msec -= hh * 1000 * 60 * 60;
    let mm = Math.floor(msec / 1000 / 60);
    msec -= mm * 1000 * 60;
    let ss = Math.floor(msec / 1000);
    msec -= ss * 1000;
    $('#time').text('Due: '+ hh +':'+ mm + ':' + ss);
}
function clicked() {
    $('#infobtns').children('li').css('background-color', '#0F0F0F08');
    $('#infobtns').children('li').css('border-bottom', '1px solid black');
    $(this).css('background-color', 'white');
    $(this).css('border-bottom', 'none');
}
function countChar() {
    let inputStr = $(this).val();
    $('#counter').text(inputStr.length +' / 100');
}
function toggleHeart() {
    if(b_wish){
        $(this).html('<i class="far fa-heart"></i>&nbsp;Wish');
    }
    else{
        $(this).html('<i class="fas fa-heart"></i>&nbsp;Wish');
    }
    b_wish = !b_wish;
}
function logout() {
    Cookies.remove('username', {path:'/', domain:'localhost'});
    window.location.reload();
}

//get brief infos from server.
$.ajax({
    url: 'http://localhost:8080/myapp/server/product.jsp',
    data: { prdId: prdId },
    method: 'GET',
    dataType: 'json'
}).done((json)=> {
    console.log(json);
    //$('#product-img').attr('src', json.imgUrl);
    $('#product-img').attr('src', 'data:image/jpg;base64, '+ json.img);
    $('#name').text(json.prdName);
    $('#price').text(json.wishPrice+'won');
    $('#description').append('<p>'+json.article+'</p>');
    showTime(json.endTime);
    window.setInterval(showTime, 1000, json.endTime);
})
.fail((jqXHR, textStatus, errorThrown)=> {
    console.log('failed');
});

$('#infobtns').children('li').click(clicked);
$('#comm-field').on('change input paste keyup', countChar);
$('#bid-wishlist').click(toggleHeart);

//if cookie is not set, remove login and register button.
if( !(userNameVal == undefined || userNameVal == null) ) {
    $('#auth').children().remove();
    $('#auth').append('<li><a href="profile.html">Welcome! '+userNameVal+'</a></li>');
    $('#auth').append('<li><a id="logout" href="../../index.html">logout</a></li>');
    $('#logout').click(logout);
}