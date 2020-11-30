const urlParams = new URLSearchParams(window.location.search);

function sendForm() {
    const regiForm = $('#regi-form');
    const pw = $('user-pw')[0];
    const pwRemind = $('pw-remind')[0];

    if(pw === pwRemind)
        regiForm.submit();
}

const isSuccess = urlParams.get('isSuccess');
if(isSuccess == 'true' || isSuccess == true) {
    alert('You\'re Registered!');
    window.location.href = 'http://localhost:8080/myapp/index.html';
} 
else if (isSuccess == 'false' || isSuccess == false ) {
    alert('Please fill the form correctly.');
}
$('#submit-btn').click(sendForm);