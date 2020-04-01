function setup() {
  createCanvas(windowHeight, windowWidth);
  background(255);
  strokeWeight(8);
}

function draw() {
  if(keyIsPressed){
    if(key == "r"){
      stroke(255, 0, 0);
    }
    if(key == "g"){
      stroke(0, 255, 0);
    }
    if(key == "b"){
      stroke(0, 0, 255);
    }
    if(key == "e"){
      stroke(255, 255, 255);
    }
  }
  
  
  if(mouseIsPressed){
    line(pmouseX, pmouseY, mouseX, mouseY);
  }
  
}
