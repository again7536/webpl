const userNameVal = Cookies.get('username');
const searchForm = $('#search-form');
const searchBar = $('#search-bar');
const urlParams = new URLSearchParams(window.location.search);
searchBar.value = urlParams.get('search-bar');

function sendForm() {
    searchForm.submit();
};
function clicked() {
    $('#infobtns').children('li').css('background-color', '#0F0F0F08');
    $('#infobtns').children('li').css('border-bottom', '1px solid black');
    $(this).css('background-color', 'white');
    $(this).css('border-bottom', 'none');
}
function logout() {
    Cookies.remove('username', {path:'/', domain:'localhost'});
    window.location.reload();
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
    $('#infobtns').children('li').click(clicked);
    $('#name').text(userNameVal);
    //get brief infos from server.
    $.ajax({
        url: 'http://localhost:8080/myapp/server/profile.jsp',
        data: { username: userNameVal },
        method: 'GET',
        dataType: 'json'
    }).done((json)=> {
        console.log(json);
        $('#greeting').text(json.greeting);
    })
    .fail((jqXHR, textStatus, errorThrown)=> {
        console.log('failed');
    });
}
