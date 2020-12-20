const searchForm = $('#search-form');
const searchBar = $('#search-bar');
const urlParams = new URLSearchParams(window.location.search);
const userNameVal = Cookies.get('username');
const prdId = urlParams.get('id');
let b_wish = false;
let curPrice = 0;

function sendForm() {
    searchForm.submit();
};
function showTime(endTime) {
    let diff = Date.parse(endTime) - Date.now();
    let msec = diff;
    let hh = Math.floor(msec / 1000 / 60 / 60);
    if(diff < 0) window.location.reload();
    if(hh>=72) {
        let dd = Math.floor(msec / 24 / 1000 / 60 / 60);
        $('#time').text(dd +' days left')
    }
    else {
        msec -= hh * 1000 * 60 * 60;
        let mm = Math.floor(msec / 1000 / 60);
        msec -= mm * 1000 * 60;
        mm = mm < 10 ? '0' + mm : mm;
        let ss = Math.floor(msec / 1000);
        msec -= ss * 1000;
        ss = ss < 10 ? '0' + ss : ss;
        $('#time').text(hh +':'+ mm + ':' + ss);
    }
}
function btnClicked() {
    $('#infobtns').children('li').css('background-color', '#0F0F0F08');
    $('#infobtns').children('li').css('border-bottom', '1px solid black');
    $(this).css('background-color', 'white');
    $(this).css('border-bottom', 'none');
}
function countChar() {
    let inputStr = $(this).val();
    $('#counter').text(inputStr.length +' / 100');
}
function addWishList() {
    if(b_wish) {
        $(this).html('<i class="far fa-heart"></i>&nbsp;Wish');
        $(this).css('background-color', '#CCCCCC');
    }
    else{
        $(this).html('<i class="fas fa-heart"></i>&nbsp;Wish');
        $(this).css('background-color', '#FC525C');
    }
    b_wish = !b_wish;
    //get brief infos from server.
    $.ajax({
        url: 'http://localhost:8080/myapp/server/wish.jsp',
        data: { prdId: prdId, userName: userNameVal, b_wish: b_wish },
        method: 'GET',
        dataType: 'json',
    }).done((json)=> {
        console.log(json);
    })
    .fail((jqXHR, textStatus, errorThrown)=> {
        console.log(errorThrown);
    });
};
function addToCart() {
    //get brief infos from server.
    $.ajax({
        url: 'http://localhost:8080/myapp/server/addcart.jsp',
        data: { prdId: prdId, userName: userNameVal },
        method: 'GET',
        dataType: 'json',
    }).done((json)=> {
        if(json.isSuccess==false)
            alert(json.msg);
        else
            alert('Added to Cart!');
    })
    .fail((jqXHR, textStatus, errorThrown)=> {
        console.log(errorThrown);
    });
}
function buy() {
    //get brief infos from server.
    $.ajax({
        url: 'http://localhost:8080/myapp/server/buy.jsp',
        data: { prdId: prdId, userName: userNameVal },
        method: 'GET',
        dataType: 'json',
    }).done((json)=> {
        alert('you bought it!');
        window.location.reload();
    })
    .fail((jqXHR, textStatus, errorThrown)=> {
        console.log(errorThrown);
    });
}
function remove() {
    //get brief infos from server.
    $.ajax({
        url: 'http://localhost:8080/myapp/server/remove.jsp',
        data: { prdId: prdId },
        method: 'GET',
        dataType: 'json',
    }).done((json)=> {
        alert('product deleted!');
        window.location.href = 'http://localhost:8080/myapp/index.html';
    })
    .fail((jqXHR, textStatus, errorThrown)=> {
        console.log(errorThrown);
    });
}
function modify() {
    window.location.href = 'http://localhost:8080/myapp/static/views/sell.html?modify=true&prdId='+prdId;
}
function logout() {
    Cookies.remove('username', {path:'/', domain:'localhost'});
    Cookies.remove('cart', {path:'/', domain:'localhost'});
    window.location.reload();
}
function Search() {
    $('#search-form')[0].submit();
}
function sendBid() {
    $('#bid-form #bid-user').val(userNameVal);
    $('#bid-form #bid-id').val(prdId);
    let bidPrice = $('#bid-form #bid-price').val();
    if(bidPrice < curPrice)
        alert('Bid price should be larger than current price!');
    else
        $('#bid-form').submit();
}
function showOption(e) {
    if($(this).closest('#search-form').length) 
        $('#search-option').css('visibility', 'visible');
    else 
        $('#search-option').css('visibility', 'hidden');
    e.stopPropagation();
}

//get brief infos from server.
$.ajax({
    url: 'http://localhost:8080/myapp/server/product.jsp',
    data: { prdId: prdId, userName: userNameVal},
    method: 'GET',
    dataType: 'json'
}).done((json)=> {
    $('#product-img').attr('src', 'data:image/jpg;base64, '+ json.prd.img);
    $('#name').text(json.prd.prdName);
    $('#place').append(`<i class="fas fa-map-marker-alt">${json.prd.place}</i>`);
    $('#price').append(`&#8361;${json.prd.curPrice}`);
    $('#description').append('<p>'+json.prd.article+'</p>');
    $('#seller-name').text(json.prd.sellerName);
    $('#phone').text('Tel:' + json.prd.phone);
    if(json.prd.bidderName)
        $('#bidder-name').text('Current Bidder : '+json.prd.bidderName);

    //if the product is already sold out.
    if(json.prd.isSold){
        $('#time').text('Sold out');
        $('#time').css('font-size', '45pt');
        $('#time').css('font-family', 'Georgia, "Times New Roman", Times, serif');
        $('#bid-wrap').remove();
    }
    // if the product is not sold out,
    else {
        let timeDiff = Date.parse(json.prd.endTime) - Date.now();

        //when product auction is ended,
        if(timeDiff < 0) {
            $('#time').text('timeout');
            $('#bid-form').remove();
            $('#bid-cart').click(() => alert('Expired product cannot be added'));
        }
        else {
            showTime(json.prd.endTime);
            window.setInterval(showTime, 1000, json.prd.endTime);
            curPrice = json.prd.curPrice;
            $('#bid-cart').click(addToCart);
        }


        //if seller name is same as user name.
        if(json.prd.sellerName == userNameVal) {
            $('#bid-buy').text('Remove');
            $('#bid-cart').text('Modify');
            $('#bid-buy').click(remove);
            $('#bid-cart').click(modify);
            $('#bid-form').remove();
        }
        else {
            $('#bid-submit').click(sendBid);
            if(json.prd.isBidding == false) {
                $('#bid-form').remove();
                if(timeDiff < 0)
                    $('#bid-buy').click( ()=>alert('Cannot buy expired item'))
                else
                    $('#bid-buy').click(buy);
            }
            else if(timeDiff < 0){
                if(json.prd.bidderName == userNameVal)
                    $('#bid-buy').click(buy);
                else
                    $('#bid-buy').click( ()=>alert('Only auction winner can buy it'))
            }    
            else{
                $('#bid-buy').click( ()=>alert('Cannot buy currently bidding item!') );
            }
        }
        //if it is added to wishlist, change appearance.
        if(json.wish.b_wish == true) {
            b_wish = true;
            $('#bid-wishlist').html('<i class="fas fa-heart"></i>&nbsp;Wish');
            $('#bid-wishlist').css('background-color', '#FC525C');
        }
    }
})
.fail((jqXHR, textStatus, errorThrown)=> {
    console.log('failed');
});

$('#infobtns').children('li').click(btnClicked);
$('#comm-field').on('change input paste keyup', countChar);
$('#bid-wishlist').click(addWishList);
$('html *').click(showOption);
$('#search-btn *').click(Search);
//if cookie is not set, remove login and register button.
if( !(userNameVal == undefined || userNameVal == null) ) {
    $('#auth').children().remove();
    $('#auth').append('<li><a href="profile.html">Welcome! '+userNameVal+'</a></li>');
    $('#auth').append('<li><a id="logout" href="../../index.html">logout</a></li>');
    $('#logout').click(logout);
};