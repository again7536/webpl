const searchForm = document.getElementById('search-form');
const urlParams = new URLSearchParams(window.location.search);
const userName = $('#username');
const userNameVal = Cookies.get('username');

function sendForm() {
    searchForm.submit();
};
function uploadFile(e){
    $('#upload-img').trigger('click');
};
function getFile(){
    const input = $('#upload-img').prop('files')[0];
    if (input) {
        console.log(input);
        var reader = new FileReader();
        reader.onload = ()=>{
            $('#preview').attr('src', reader.result);
        };
        reader.readAsDataURL(input);
        console.log(reader.result);
    }
};
function logout() {
    Cookies.remove('username', {path:'/', domain:'localhost'});
    window.location.reload();
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
    userName.value = userNameVal;
    //check that the request is sent correctly.
    let success = urlParams.get('isSuccess');
    if(success == false) {
        alert('Please write down every form.');
    } else if(success == true) {
        alert('Product enrollment successed');
    }
    $("#preview").click(uploadFile);
    $('#upload-img').on('change', getFile);
    $('#submit-btn').click(()=>{
        $('.upload-form')[0].submit();
    });
}