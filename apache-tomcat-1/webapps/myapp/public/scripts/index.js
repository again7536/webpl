const slider = document.getElementById('slider');
const left_btn = document.getElementById('left-btn');
const right_btn = document.getElementById('right-btn');
const slider_cnt = slider.childElementCount;

const search_btn = document.getElementById('search-btn');
const searchForm = document.getElementById('search-form');

const userNameVal = Cookies.get('username');

function Search() {
   $('#search-form')[0].submit();
}
function logout() {
    Cookies.remove('username', {path:'/', domain:'localhost'});
    console.log('nope');
    window.location.reload();
}

function showOption(e) {
    if($(this).closest('#search-form').length)
        $('#search-option').css('visibility', 'visible');
    else 
        $('#search-option').css('visibility', 'hidden');
    e.stopPropagation();
}

var index = 0;
var moveRatio = 100.0/slider_cnt;
left_btn.addEventListener('click', (event)=>{
    index--;
    if(index == -1) {
        index = slider_cnt-1;
        slider.style.transform=`translateX(${-index * moveRatio}%)`;
    } 
    else slider.style.transform=`translateX(${-index * moveRatio}%)`;
});
right_btn.addEventListener('click', (event)=>{
    index++;
    if(index == slider_cnt) {
        index = 0;
        slider.style.transform=`translateX(${-index * moveRatio}%)`;
    }
    else slider.style.transform=`translateX(${-index * moveRatio}%)`;
});

//if cookie is not set, remove login and register button.
if( !(userNameVal == undefined || userNameVal == null) ) {
    $('#auth').children().remove();
    $('#auth').append('<li><a href="static/views/profile.html">Welcome! '+userNameVal+'</a></li>');
    $('#auth').append('<li><a id="logout" href="index.html">logout</a></li>');
    $('#logout').click(logout);
}

$('#search-btn *').click(Search);
$('html *').click(showOption);
