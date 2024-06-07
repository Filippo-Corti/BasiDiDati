const toasts = document.querySelectorAll('.toast');
const toastsBootstrap = [];
toasts.forEach(toast => {
    const toastBootstrap = bootstrap.Toast.getOrCreateInstance(toast);
    toastBootstrap.show();
    toastsBootstrap.push(toastBootstrap);
});