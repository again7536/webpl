const searchForm = document.getElementById('search-form');
const urlParams = new URLSearchParams(window.location.search);
const searchBar = document.getElementById('search-bar');
const userNameVal = Cookies.get('username');

function sendForm() {
    searchForm.submit();
};
function logout() {
    Cookies.remove('username', {path:'/', domain:'localhost'});
    Cookies.remove('cart', {path:'/', domain:'localhost'});
    window.location.reload();
}
function Search() {
    $('#search-form')[0].submit();
 }
function showOption(e) {
    if($(this).closest('#search-form').length) 
        $('#search-option').css('visibility', 'visible');
    else 
        $('#search-option').css('visibility', 'hidden');
    e.stopPropagation();
}

searchBar.value = urlParams.get('product');
$.ajax({
    url: 'http://localhost:8080/myapp/server/list.jsp',
    data: { search: urlParams.get('product'),
            seller: urlParams.get('seller'),
            minPrice: urlParams.get('min-price'),
            maxPrice: urlParams.get('max-price'),
    },
    method: 'GET',
    dataType: 'json'
}).done((json)=> {
    console.log('hey');
    console.log(json);
    let cnt = 0;
    for (const item of json) {
        let cname = !cnt%3 ? 'one_quarter first' : 'one_quarter';
        let list = `
        <li class="${cname}">
            <article>
                <a href="product.html?search=${searchBar.value}&id=${item.prdId}">\
                    <img class="item-img" src=data:image/jpg;base64,${item.img}></img>\
                    <h6 class="item-name">${item.prdName}</h6>\
                    <h6 class="item-price">&#8361;${item.curPrice}</h6>\
                    <hr><p>${item.isBidding?'now on bidding':''}</p>\
                    <h6 class="item-place">${item.place}</h6>\
                </a>
            </article>
        </li>`;
        $('#products').append(list);
        cnt++;
    }
})
.fail((jqXHR, textStatus, errorThrown)=> {
    console.log('failed');
});

//if cookie is not set, remove login and register button.
if( !(userNameVal == undefined || userNameVal == null) ) {
    $('#auth').children().remove();
    $('#auth').append('<li><a href="static/views/profile.html">Welcome! '+userNameVal+'</a></li>');
    $('#auth').append('<li><a id="logout" href="../../index.html">logout</a></li>');
    $('#logout').click(logout);
}

$('#search-btn *').click(Search);
$('html *').click(showOption);

