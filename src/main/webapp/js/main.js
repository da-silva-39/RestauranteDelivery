// Smooth scroll para links internos
document.querySelectorAll('.nav-links a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if(target) target.scrollIntoView({ behavior: 'smooth' });
    });
});

// Adicionar item ao campo de texto do pedido
document.querySelectorAll('.btn-pedido').forEach(btn => {
    btn.addEventListener('click', () => {
        const nomePrato = btn.getAttribute('data-nome');
        const textarea = document.querySelector('.pedido-form textarea');
        if(textarea) {
            let current = textarea.value;
            textarea.value = current ? current + `\n- ${nomePrato}` : `- ${nomePrato}`;
            document.getElementById('pedido').scrollIntoView({ behavior: 'smooth' });
        }
    });
});