const select    = document.getElementById('example-select');
const container = document.getElementById('text-container');

function loadExample(num) {
  if (!num) return;
  select.value = num;

  var xhr = new XMLHttpRequest();
  xhr.open('GET', '/get-example/' + num, true);
  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4 && xhr.status === 200) {
      var data = JSON.parse(xhr.responseText);
      container.textContent = data.content || data.error;
      container.style.display = 'block';
    }
  };
  xhr.send();
}

document.getElementById('showExample').addEventListener('click', function () {
  loadExample(select.value);
});

document.getElementById('prevExample').addEventListener('click', function () {
  var cur = parseInt(select.value) || 2;
  loadExample(cur === 1 ? 3 : cur - 1);
});

document.getElementById('nextExample').addEventListener('click', function () {
  var cur = parseInt(select.value) || 0;
  loadExample(cur === 3 ? 1 : cur + 1);
});