function sendForm() {
    let queryString = $('#login-form').serialize();
    $.ajax({
        url: 'http://localhost:8080/myapp/server/login.jsp',
        data: queryString,
        method: 'GET',
        dataType: 'json',
    }).done((json)=> {
        if(json.isSuccess){
            alert('you\'re logged in!');
            window.location.href = 'http://localhost:8080/myapp/index.html';
        }
        else alert('Please write valid ID and password');
    })
    .fail((jqXHR, textStatus, errorThrown)=> {
        console.log(errorThrown);
    });
}
$('#submit-btn').click(sendForm);