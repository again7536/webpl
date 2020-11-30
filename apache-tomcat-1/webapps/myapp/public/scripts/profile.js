const userNameVal = Cookies.get('username');
const searchForm = $('#search-form');
const searchBar = $('#search-bar');
const urlParams = new URLSearchParams(window.location.search);
searchBar.value = urlParams.get('search-bar');

function sendForm() {
    searchForm.submit();
};
function goProduct() {
    let id = $(this).children('.prd-hid').text();
    window.location.href = 'http://localhost:8080/myapp/static/views/product.html?id='+id;
}
function menuClicked() {
    $('#infobtns').children('li').css('background-color', '#0F0F0F08');
    $('#infobtns').children('li').css('border-bottom', '1px solid black');
    $(this).css('background-color', 'white');
    $(this).css('border-bottom', 'none');
}
function logout() {
    Cookies.remove('cart', {path:'/', domain:'localhost'});
    Cookies.remove('username', {path:'/', domain:'localhost'});
    window.location.reload();
}
function initialize() {
    $('#datas').html('');
}
function getBidHistory() {
    $('.prd-up').html('&#11206;');
    $('.prd-up').off('click');
    $('.prd-up').click(getBidHistory);
    $('.prd-up').attr('class', 'prd-down');
    $('.history').remove();
    const prdId = $(this).prev().children('.prd-hid').text();
    console.log(prdId);
    //get brief infos from server.
    $.ajax({
        url: 'http://localhost:8080/myapp/server/history.jsp',
        data: { prdId: prdId },
        method: 'GET',
        dataType: 'json'
    }).done((json)=> {
        console.log(json);
        $(this).parent().after('<div class="history"></div>');
        for(hist of json) {
            $('.history').append(
                `<div class="hist-item">
                    <div class="hist-time">${hist.time}</div>\
                    <div class="hist-name">${hist.bidderName}</div>
                    <div class="hist-price">${hist.price}</div>\
                </div>`);
        }
        $(this).attr('class', 'prd-up');
        $(this).off('click');
        $(this).click(hideBidHistory);
        $(this).html('&#11205;');
    }).fail((jqXHR, textStatus, errorThrown)=> {
        console.log('failed');
        console.log(errorThrown);
    });
}
function hideBidHistory() {
    $('.history').remove();
    $(this).attr('class', 'prd-down');
    $(this).off('click');
    $(this).click(getBidHistory);
    $(this).html('&#11206;');
}
function getWishList() {
    initialize();
    //get brief infos from server.
    $.ajax({
        url: 'http://localhost:8080/myapp/server/getwish.jsp',
        data: { username: userNameVal },
        method: 'GET',
        dataType: 'json'
    }).done((json)=> {
        console.log(json);
        for(prd of json) {
            $('#datas').append(`<div class="item">\
                                    <div class="prd-data">\
                                        <div class="prd-hid" hidden>${prd.prdId}</div>
                                        <img src='data:image/jpg;base64, ${prd.img}'>\
                                        <div class="prd-info">\
                                            <h2>${prd.prdName}</h2>\
                                            <h3><i class="fas fa-map-marker-alt"></i>${prd.place}</h3><hr>\
                                            <h4>${prd.isSold?'sold out':prd.isBidding?'currently on bidding':'on sale as'}</h4>\
                                            <h4>&#8361;${prd.curPrice}</h4>
                                        </div>\
                                    </div>\
                                </div>`);
        }
        $('.prd-data').click(goProduct);
    }).fail((jqXHR, textStatus, errorThrown)=> {
        console.log('failed');
    });
}
function getSellList() {
    initialize();
   //get brief infos from server.
   $.ajax({
        url: 'http://localhost:8080/myapp/server/getsell.jsp',
        data: { username: userNameVal },
        method: 'GET',
        dataType: 'json'
    }).done((json)=> {
        console.log(json);
        for(prd of json) {
            $('#datas').append(`<div class="item">
                                    <div class="prd-data"><img src='data:image/jpg;base64, ${prd.img}'>\
                                        <div class="prd-hid" hidden>${prd.prdId}</div>
                                        <div class="prd-info">\
                                            <h2>${prd.prdName}</h2>\
                                            <h3><i class="fas fa-map-marker-alt"></i>${prd.place}</h3><hr>\
                                            <h4>${prd.isSold?'sold out':prd.isBidding?'currently on bidding':'on sale as'}</h4>\
                                            <h4>&#8361;${prd.curPrice}</h4>
                                        </div>\
                                    </div>
                                    <div class="prd-down">&#11206;</div>
                                </div>`);
        }
        $('.prd-data').click(goProduct);
        $('.prd-down').click(getBidHistory);
    }).fail((jqXHR, textStatus, errorThrown)=> {
        console.log('failed');
    });
}
function getBuyList() {
    initialize();
   //get brief infos from server.
   $.ajax({
        url: 'http://localhost:8080/myapp/server/getbuy.jsp',
        data: { username: userNameVal },
        method: 'GET',
        dataType: 'json'
    }).done((json)=> {
        console.log(json);
        for(prd of json) {
            $('#datas').append(`<div class="item">\
                                    <div class="prd-data">\
                                        <div class="prd-hid" hidden>${prd.prdId}</div>
                                        <img src='data:image/jpg;base64, ${prd.img}'>\
                                        <div class="prd-info">\
                                            <h2>${prd.prdName}</h2>\
                                            <h3><i class="fas fa-map-marker-alt"></i>${prd.place}</h3><hr>\
                                            <h4>${prd.isSold?'sold out':prd.isBidding?'currently on bidding':'on sale as'}</h4>\
                                            <h4>&#8361;${prd.curPrice}</h4>
                                        </div>\
                                    </div>\
                                </div>`);
        }
        $('.prd-data').click(goProduct);
    }).fail((jqXHR, textStatus, errorThrown)=> {
        console.log('failed');
    });
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
    $('#infobtns').children('li').click(menuClicked);
    $('#name').text(userNameVal);
    $('#greeting').text()
    $('#wish-btn').click(getWishList);
    $('#buy-btn').click(getBuyList);
    $('#sell-btn').click(getSellList);

    $.ajax({
        url: 'http://localhost:8080/myapp/server/profile.jsp',
        data: { username: userNameVal },
        method: 'GET',
        dataType: 'json'
    }).done((json)=> {
        console.log(json);
        $('#greeting').text(json.greeting);
    }).fail((jqXHR, textStatus, errorThrown)=> {
        console.log('failed');
    });
    getSellList();
}
