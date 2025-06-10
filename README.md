About
===
rendering mash with vertex arrays
---
How to Use
===
1. Download zip piles.

![download zip](https://github.com/user-attachments/assets/3e76e9d2-5325-42a3-ba52-2bb3064c0a58)

2. Unzip the folder
3. open "OpenglViewer.sln"

![leanch](https://github.com/user-attachments/assets/1ed43ef3-d812-4b75-809d-fe1077eabf9b)

---
Result of assignmet8-2
FPS= 1924
![스크린샷 2025-05-08 162804](https://github.com/user-attachments/assets/179262b1-aad9-494e-8ff5-0a0eb55454ab)

---
Explanation
---

The big frame itself is the same as Q1, but only a few parts are different

The main function calls the setupQ2Buffers() function only once after the load_mesh call and before the rendering loop starts.

![image](https://github.com/user-attachments/assets/28b39fcc-fcba-4e96-bade-9e0fe602d577)

Role of setupQ2Buffers(): This function is responsible for creating VBOs and EBOs and permanently copying all vertex data from the CPU to GPU memory via glBufferData.

![image](https://github.com/user-attachments/assets/78feb248-f32e-4f61-80bb-778fbebefb96)
