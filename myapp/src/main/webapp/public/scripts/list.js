const searchForm = document.getElementById('search-form');
const urlParams = new URLSearchParams(window.location.search);
const searchBar = document.getElementById('search-bar');
const userNameVal = Cookies.get('username');

function sendForm() {
    searchForm.submit();
};
function logout() {
    Cookies.remove('username', {path:'/', domain:'localhost'});
    window.location.reload();
}

searchBar.value = urlParams.get('search-bar');
$.ajax({
    url: 'http://localhost:8080/myapp/server/list.jsp',
    data: { search: searchBar.value},
    method: 'GET',
    dataType: 'json'
}).done((json)=> {
    console.log('hey');
    console.log(json);
    let cnt = 0;
    for (const item of json) {
        let cname = !cnt%3 ? 'one_quarter first' : 'one_quarter';
        let li = '<li class="'+cname+'"></li>';
        let article = '<article></article>';
        let a = '<a href="product.html?search='+searchBar.value+'&id='+item.prdId+'"></a>';
        let img = '<img></img>';
        img = $(img);
        img.attr('src', 'data:image/jpg;base64, '+ item.img);
        let h6_1 = '<h6 class="heading">'+item.prdName+'</h6>';
        let h6_2 = '<h6 class="heading">$'+item.wishPrice+'</h6>';
        let p = `<hr><p>${item.isBidding?'now on bidding':''}</p>`;
        a = $(a).append(img);
        a = $(a).append(h6_1);
        a = $(a).append(h6_2);
        a = $(a).append(p);
        article = $(article).append(a);
        li = $(li).append(article);
        $('#products').append(li);
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

