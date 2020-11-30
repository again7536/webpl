function sendForm() {
    let queryString = $('#regi-form').serialize();
    const pw = $('#user-pw').val();
    const pwRemind = $('#pw-remind').val();

    if(pw === pwRemind)
        $.ajax({
            url: 'http://localhost:8080/myapp/server/register.jsp',
            data: queryString,
            method: 'GET',
            dataType: 'json',
        }).done((json)=> {
            console.log(json);
            if(json.isSuccess){
                alert('you\'re registered!');
                window.location.href = 'http://localhost:8080/myapp/index.html';
            }
            else alert(json.msg);
        })
        .fail((jqXHR, textStatus, errorThrown)=> {
            console.log(errorThrown);
        });
    else alert('Please match password and password remind.');
}

$('#submit-btn').click(sendForm);