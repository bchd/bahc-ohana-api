document.addEventListener('turbolinks:load', () => {
    const mapView = document.getElementById('map-view');
    const mapToggle = document.getElementById('map-toggle');
    const mapCanvas = document.getElementById('map-canvas');
  
    if (mapToggle && mapView && mapCanvas) {
      mapToggle.addEventListener('click', () => {
        mapView.classList.toggle('map-hidden');
        
        if (mapView.classList.contains('map-hidden')) {
          mapToggle.querySelector('.show-map').style.display = 'inline';
          mapToggle.querySelector('.hide-map').style.display = 'none';
          mapCanvas.style.display = 'none';
        } else {
          mapToggle.querySelector('.show-map').style.display = 'none';
          mapToggle.querySelector('.hide-map').style.display = 'inline';
          mapCanvas.style.display = 'block';
        }
      });
    }
  });
