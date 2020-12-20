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
function buyAll() {
    let isSuccess = true;
    $('.cart-item').each((index, element)=>{
        const buyPrdId = $(element).children('.item-hid').text();
        const isBidding = $(element).children('.item-status').text();
        if(isBidding == false) {
            //get brief infos from server.
            $.ajax({
                url: 'http://localhost:8080/myapp/server/buy.jsp',
                data: { prdId: buyPrdId, userName: userNameVal },
                method: 'GET',
                dataType: 'json',
            }).done((json)=> {
            })
            .fail((jqXHR, textStatus, errorThrown)=> {
                isSuccess = false;
                console.log(errorThrown);
            });
        }
    });

    if(isSuccess == true) {
        alert('You bought every item in cart!');
        window.location.reload();
    }
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
        if(!item.isBidding)
            bidding = false;
        else if(Date.parse(item.endTime) < Date.now()) {
            bidding = false;
            if(item.bidderName !== userNameVal) continue;
        }

        $('#cart-list').append(`
        <li class="cart-item">
            <div class="item-hid" hidden>${item.prdId}</div>
            <div class="item-status" hidden>${String(bidding)}</div>\
            <img src="data:image/jpg;base64,${item.img}">
            <div class="item-section">
                <h2>${item.prdName}</h2>
                <hr><h3><i class="fas fa-map-marker-alt"></i>${item.place}</h3>
            </div>
                <div class="item-section">\
                <h4>${bidding ? 'Currently on Bidding' : '&#8361;'+item.curPrice}</h4>
            </div>
        </li>`);
        if(!bidding) priceSum += item.curPrice;
    }
    $('#total-val').html('&#8361;'+priceSum);
}).fail((jqXHR, textStatus, errorThrown) => {
    console.log('failed');
});

$('#cart-btn').click(buyAll);
$('html *').click(showOption);
$('#search-btn *').click(Search);
//if cookie is not set, remove login and register button.
if( !(userNameVal == undefined || userNameVal == null) ) {
    $('#auth').children().remove();
    $('#auth').append('<li><a href="profile.html">Welcome! '+userNameVal+'</a></li>');
    $('#auth').append('<li><a id="logout" href="../../index.html">logout</a></li>');
    $('#logout').click(logout);
}