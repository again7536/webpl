const urlParams = new URLSearchParams(window.location.search);

function sendForm() {
    const regiForm = $('#login-form');
    regiForm.submit();
}

const isSuccess = urlParams.get('isSuccess');
if(isSuccess == 'true' || isSuccess == true) {
    alert('You\'re Logged In!');
    window.location.href = 'http://localhost:8080/myapp/index.html';
} 
else if (isSuccess == 'false' || isSuccess == false) {
    alert('Please fill the form correctly.');
}
$('#submit-btn').click(sendForm);

