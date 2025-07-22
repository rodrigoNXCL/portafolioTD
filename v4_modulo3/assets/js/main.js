// jQuery: Mostrar/Ocultar la bio
$(document).ready(function() {
  $('#toggleBio').click(function() {
    $('#bio').slideToggle();
  });
});

// JS puro: Cambiar color del header al pasar mouse
document.querySelector('header').addEventListener('mouseenter', function() {
  this.style.backgroundColor = '#e3f2fd';
});
document.querySelector('header').addEventListener('mouseleave', function() {
  this.style.backgroundColor = '';
});

// mejora la validacion del formulario
document.addEventListener('DOMContentLoaded', function() {
  const form = document.querySelector('form');
  form.addEventListener('submit', function(e) {
    if(document.getElementById('email').value.trim() === '') {
      alert('Por favor, ingresa tu correo.');
      e.preventDefault();
    }
  });
});