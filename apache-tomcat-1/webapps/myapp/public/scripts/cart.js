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

$.ajax({
    url: 'http://localhost:8080/myapp/server/getcart.jsp',
    data: { userName: userNameVal},
    method: 'GET',
    dataType: 'json'
}).done((json)=> {
    console.log(json);
    let priceSum = 0;
    for (const item of json) {
        let bidding = true;
        if(!item.isBidding || item.endTime > Date.now()) bidding = false;

        $('#cart-list').append(`
        <li class="cart-item">
            <div class="item-hid" hidden>${item.prdId}</div>
            <img src="data:image/jpg;base64,${item.img}">
            <div class="item-section">
                <h2>${item.prdName}</h2>
                <hr><h3><i class="fas fa-map-marker-alt"></i>${item.place}</h3>
            </div>
                <div class="item-section">
                <h4>${bidding ? 'Currently on Bidding' : '&#8361;'+item.price}</h4>
            </div>
        </li>`);
        if(!bidding) priceSum += item.curPrice;
    }
    $('#total-val').html('&#8361;'+priceSum);
}).fail((jqXHR, textStatus, errorThrown) => {
    console.log('failed');
});

//if cookie is not set, remove login and register button.
if( !(userNameVal == undefined || userNameVal == null) ) {
    $('#auth').children().remove();
    $('#auth').append('<li><a href="static/views/profile.html">Welcome! '+userNameVal+'</a></li>');
    $('#auth').append('<li><a id="logout" href="../../index.html">logout</a></li>');
    $('#logout').click(logout);
}