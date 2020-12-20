function deleteUser() {
    const userId = $(this).next().text();
    if(userId == 'admin') return;
    $.ajax({
        url: 'http://localhost:8080/myapp/server/deluser.jsp',
        data: {userId:userId},
        method: 'GET',
        dataType: 'json'
    }).done((json)=> {
        $(this).parent().remove();
    });
}

$.ajax({
    url: 'http://localhost:8080/myapp/server/getuser.jsp',
    data: {},
    method: 'GET',
    dataType: 'json'
}).done((json)=> {
    let cnt = 0;
    for (const user of json) {
        $('#data').append(`<li class="row">
                                <div class="del-btn">-</div>
                                <div>${user.userId}</div>
                                <div>${user.userName}</div>
                                <div>${user.level}</div>
                            </li>`);
    }
    $('.del-btn').click(deleteUser);
});

