
document.getElementById('formConnexion').addEventListener('submit', function (e) {
    // Empêche le rechargement de la page
    e.preventDefault();

    // Étapes suivantes ici
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;

    const formData = new FormData();
    formData.append('email', email);
    formData.append('password', password);

    fetch('login.php', {
        method: 'POST',
        body: formData
    })
        .then(response => response.json())
        .then(data => {
            const msg = document.getElementById('message');
            if (data.status === 200) {
                msg.innerHTML = `<div class="alert alert-success">${data.message}</div>`;
            } else {
                msg.innerHTML = `<div class="alert alert-danger">${data.message}</div>`;
            };
            console.log(data);
        })
        .catch(error => {
            document.getElementById('message').innerHTML = `<div class="alert alert-warning">Erreur réseau</div>`;
            console.error('Erreur :', error);
        });
});