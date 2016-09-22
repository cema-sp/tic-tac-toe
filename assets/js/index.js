import { Main } from 'elm/Main';

const mountPoint = document.getElementById('application');
if (typeof Main !== "undefined") {
  mountPoint.innerHTML = '';
  Main.embed(mountPoint);
} else {
  mountPoint.innerHTML = "Error loading script!";
}

