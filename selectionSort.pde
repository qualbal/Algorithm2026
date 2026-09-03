int[] list = new int[100];

for (int i = 0; i < list.length; i++) {
  list[i] = (int) random(1000);
}
println(list.length);

for (int i = 0; i < list.length; i++) {
  print(list[i] + " ");
}
println();
int i, j, max, index, temp = 0;


for (i = 0; i < list.length; i++) {
  max = index = -1;
  for (j = 0; j <= list.length - i - 1; j++) {
    if (max < list[j])
    {
      max = list[j];
      index = j;
    }
  }
  
  if (index != -1) {
    int target = list.length -i -1;
    temp = list[target];
    list[target] = max;
    list[index] = temp;
  }
}

for (i = 0; i < list.length; i++)
{
  print(list[i] +  " ");
}
    

//line(0,0, 100, 100);
