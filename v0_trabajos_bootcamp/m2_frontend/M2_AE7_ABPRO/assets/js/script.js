// Validación y feedback para formulario de solicitud
document.getElementById('solicitudForm').addEventListener('submit', function(e) {
  e.preventDefault();
  // Validación básica (puedes expandirla)
  let campos = ['nombre', 'telefono', 'direccion', 'servicio', 'descripcion', 'fecha', 'turno'];
  let valido = campos.every(id => document.getElementById(id).value.trim() !== "");
  if(valido) {
    document.getElementById('alertaExito').classList.remove('d-none');
    this.reset();
    setTimeout(() => {
      document.getElementById('alertaExito').classList.add('d-none');
    }, 3000);
  } else {
    alert('Por favor, completa todos los campos.');
  }
});

// Validación y feedback para simulación de pago
document.getElementById('pagoForm').addEventListener('submit', function(e) {
  e.preventDefault();
  // Validación simple (puedes hacerla más estricta si lo deseas)
  let campos = ['titular', 'numero', 'expiracion', 'cvv'];
  let valido = campos.every(id => document.getElementById(id).value.trim() !== "");
  if(valido) {
    document.getElementById('alertaPago').classList.remove('d-none');
    this.reset();
    setTimeout(() => {
      document.getElementById('alertaPago').classList.add('d-none');
    }, 3000);
  } else {
    alert('Por favor, completa todos los campos de pago.');
  }
});
