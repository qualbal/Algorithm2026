ArrayList<Step> steps = new ArrayList<Step>();
int currentStep = 0;
String currentSortName = "Selection Sort";
int currentMode = 1; 
boolean isRunning = true;

int[] originalArray = new int[12];

class Step {
  int[] arr;
  int active1;
  int active2;
  
  Step(int[] a, int i1, int i2) {
    arr = a.clone();
    active1 = i1;
    active2 = i2;
  }
}

void setup() {
  size(800, 600);
  frameRate(15);
  
  for (int i = 0; i < 12; i++) {
    originalArray[i] = (i + 1) * 25; 
  }
  resetAndSort(currentMode);
}

void draw() {
  background(30);
  
  Step currentStepData = null;
  if (steps.size() > 0 && currentStep < steps.size()) {
    currentStepData = steps.get(currentStep);
    if (isRunning && currentStep < steps.size() - 1) {
      currentStep++;
    }
  }
  
  fill(255);
  textSize(20);
  text("Current Algorithm: " + currentSortName, 30, 40);       
  textSize(13);
  text("Controls: [1] Selection  [2] Bubble  [3] Insertion  [4] Merge  [5] Quick  [6] Heap  [R] Reset", 30, 70);
  text("Space: Pause/Resume | Step: " + currentStep + " / " + (steps.size() - 1), 30, 95);
  
  if (currentStepData != null) {
    int[] currentArray = currentStepData.arr;
    int barWidth = (width - 100) / 12;
    
    for (int i = 0; i < currentArray.length; i++) {
      int x = 50 + i * barWidth;
      int h = currentArray[i];
      int y = height - 80 - h;
      
      if (currentStep >= steps.size() - 1) {
        fill(46, 204, 113);
      } else if (i == currentStepData.active1) {
        fill(231, 76, 60);
      } else if (i == currentStepData.active2) {
        fill(241, 196, 15);
      } else {
        fill(52, 152, 219);
      }
      
      rect(x, y, barWidth - 4, h, 4);
      
      fill(255);
      textSize(11);
      textAlign(CENTER);
      text(h / 25, x + barWidth / 2 - 2, height - 55);
    }
  }
  textAlign(LEFT);
}

void keyPressed() {
  if (key == '1') { resetAndSort(1); }
  else if (key == '2') { resetAndSort(2); }
  else if (key == '3') { resetAndSort(3); }
  else if (key == '4') { resetAndSort(4); }
  else if (key == '5') { resetAndSort(5); }
  else if (key == '6') { resetAndSort(6); }
  else if (key == 'r' || key == 'R') { resetAndSort(currentMode); }
  else if (key == ' ') { isRunning = !isRunning; }
}

void resetAndSort(int mode) {
  currentMode = mode;

  for (int i = 0; i < originalArray.length; i++) {
    int idx = int(random(originalArray.length));
    int temp = originalArray[i];
    originalArray[i] = originalArray[idx];
    originalArray[idx] = temp;
  }
  
  steps.clear();
  currentStep = 0;
  isRunning = true;
  
  int[] arrCopy = originalArray.clone();
  steps.add(new Step(arrCopy, -1, -1));
  
  switch(mode) {
    case 1:
      currentSortName = "Selection Sort";
      selectionSort(arrCopy);
      break;
    case 2:
      currentSortName = "Bubble Sort";
      bubbleSort(arrCopy);
      break;
    case 3:
      currentSortName = "Insertion Sort";
      insertionSort(arrCopy);
      break;
    case 4:
      currentSortName = "Merge Sort";
      mergeSort(arrCopy, 0, arrCopy.length - 1);
      break;
    case 5:
      currentSortName = "Quick Sort";
      quickSort(arrCopy, 0, arrCopy.length - 1);
      break;
    case 6:
      currentSortName = "Heap Sort";
      heapSort(arrCopy);
      break;
  }
}

void selectionSort(int[] a) {
  for (int i = 0; i < a.length - 1; i++) {
    int minIdx = i;
    for (int j = i + 1; j < a.length; j++) {
      steps.add(new Step(a, minIdx, j));
      if (a[j] < a[minIdx]) { 
        minIdx = j; 
      }
    }
    if (minIdx != i) {
      int temp = a[i]; a[i] = a[minIdx]; a[minIdx] = temp;
      steps.add(new Step(a, i, minIdx));
    }
  }
}

void bubbleSort(int[] a) {
  for (int i = 0; i < a.length; i++) {
    for (int j = 0; j < a.length - 1 - i; j++) {
      steps.add(new Step(a, j, j + 1));
      if (a[j] > a[j+1]) {
        int temp = a[j]; a[j] = a[j+1]; a[j+1] = temp;
        steps.add(new Step(a, j, j + 1));
      }
    }
  }
}

void insertionSort(int[] a) {
  for (int i = 1; i < a.length; i++) {
    int key = a[i];
    int j = i - 1;
    while (j >= 0 && a[j] > key) {
      steps.add(new Step(a, j + 1, j));
      a[j + 1] = a[j];
      j--;
      steps.add(new Step(a, j + 1, -1));
    }
    a[j + 1] = key;
    steps.add(new Step(a, j + 1, -1));
  }
}

void mergeSort(int[] a, int l, int r) {
  if (l < r) {
    int m = l + (r - l) / 2;
    mergeSort(a, l, m);
    mergeSort(a, m + 1, r);
    merge(a, l, m, r);
  }
}

void merge(int[] a, int l, int m, int r) {
  int n1 = m - l + 1;
  int n2 = r - m;
  int[] L = new int[n1];
  int[] R = new int[n2];
  for (int i = 0; i < n1; ++i) L[i] = a[l + i];
  for (int j = 0; j < n2; ++j) R[j] = a[m + 1 + j];
  
  int i = 0, j = 0, k = l;
  while (i < n1 && j < n2) {
    if (L[i] <= R[j]) { 
      a[k] = L[i]; i++; 
    } else { 
      a[k] = R[j]; j++; 
    }
    steps.add(new Step(a, k, -1));
    k++;
  }
  while (i < n1) { 
    a[k] = L[i]; i++; 
    steps.add(new Step(a, k, -1)); 
    k++; 
  }
  while (j < n2) { 
    a[k] = R[j]; j++; 
    steps.add(new Step(a, k, -1)); 
    k++; 
  }
}

void quickSort(int[] a, int low, int high) {
  if (low < high) {
    int pi = partition(a, low, high);
    quickSort(a, low, pi - 1);
    quickSort(a, pi + 1, high);
  }
}

int partition(int[] a, int low, int high) {
  int pivot = a[high];
  int i = (low - 1);
  for (int j = low; j < high; j++) {
    steps.add(new Step(a, high, j));
    if (a[j] < pivot) {
      i++;
      int temp = a[i]; a[i] = a[j]; a[j] = temp;
      steps.add(new Step(a, i, j));
    }
  }
  int temp = a[i + 1]; a[i + 1] = a[high]; a[high] = temp;
  steps.add(new Step(a, i + 1, high));
  return i + 1;
}

void heapSort(int[] a) {
  int n = a.length;
  for (int i = n / 2 - 1; i >= 0; i--) heapify(a, n, i);
  for (int i = n - 1; i > 0; i--) {
    int temp = a[0]; a[0] = a[i]; a[i] = temp;
    steps.add(new Step(a, 0, i));
    heapify(a, i, 0);
  }
}

void heapify(int[] a, int n, int i) {
  int largest = i;
  int l = 2 * i + 1;
  int r = 2 * i + 2;
  if (l < n && a[l] > a[largest]) largest = l;
  if (r < n && a[r] > a[largest]) largest = r;
  if (largest != i) {
    int swap = a[i]; a[i] = a[largest]; a[largest] = swap;
    steps.add(new Step(a, i, largest));
    heapify(a, n, largest);
  }
}
