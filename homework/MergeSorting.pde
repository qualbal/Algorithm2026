void setup()
{
  //size(400,400);
  
  int size = 10;
  
  int[] arr= new int[size];
  
  for (int i = 0; i < size; i++)
    arr[i] = int(random(100));
  
  print("Array: ");
  printArr(arr, size);
  
  mergeSort(arr, 0, size - 1);
  
  for (int i = 0; i < size - 1; i++)
    assert(arr[i] <= arr[i + 1]);
    
    print("Sorted Array: ");
    printArr(arr, size);
}

void printArr(int[] arr, int size)
{
  for (int i = 0; i < size; i++)
    print(arr[i] + " ");
    
    println();
}

void mergeSort(int[] arr, int left, int right)
{
  if (left >= right)
    return;
    
    int mid = left + (right - left) / 2;
    
    mergeSort(arr, left, mid);
    mergeSort(arr, mid + 1, right);
    merge(arr, left, mid, right);
    
}

void merge(int[] arr, int left, int mid, int right)
{
  int val1 = mid - left + 1;
  int val2 = right - mid;
  
  int[] leftArr = new int[val1];
  int[] rightArr = new int[val2];
  
  for (int i = 0; i < val1; i++)
    leftArr[i] = arr[left + i];
    
    for (int j = 0; j < val2; j++)
      rightArr[j] = arr[mid + 1 + j];
      
      int i = 0;
      int j = 0;
      int k = left;
      
      while (i < val1 && j < val2)
      {
        if (leftArr[i] <= rightArr[j])
          arr[k++] = leftArr[i++];
        else
          arr[k++] = rightArr[j++];          
      }
      
      while (i < val1)
        arr[k++] = leftArr[i++];
        
        while (j < val2)
          arr[k++] = rightArr[j++];
}
