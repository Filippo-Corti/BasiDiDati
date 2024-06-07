const toasts = document.querySelectorAll('.toast');
console.log(toasts);
const toastsBootstrap = [];
toasts.forEach(toast => {
    const toastBootstrap = bootstrap.Toast.getOrCreateInstance(toast);
    toastBootstrap.show();
    toastsBootstrap.push(toastBootstrap);
});