About
===
Phong Shading with shader load
---
How to Use
===
1. Download zip piles.  
   
![download zip](https://github.com/user-attachments/assets/3e76e9d2-5325-42a3-ba52-2bb3064c0a58)

2. Unzip the folder  
3. open "OpenglViewer.sln"  
![leanch](https://github.com/user-attachments/assets/1ed43ef3-d812-4b75-809d-fe1077eabf9b)
---
Result of assignmet7

![스크린샷 2025-05-08 162804](https://github.com/user-attachments/assets/6a961b4f-d2ce-49ac-92f7-488fd7e83a2b)


---
Explanation
---
The LoadShaders function loads, compiles, and links vertex shaders and fragment shaders in a given file path, which creates shader objects and returns the final shader program ID

	GLuint LoadShaders(const std::string& vertex_file_path, const std::string& fragment_file_path)
	{
    // Create the shaders
    GLuint VertexShaderID = glCreateShader(GL_VERTEX_SHADER);
    GLuint FragmentShaderID = glCreateShader(GL_FRAGMENT_SHADER);

    // vertex 셰이더 코드 읽기
    std::string VertexShaderCode;
    std::ifstream VertexShaderStream(vertex_file_path.c_str(), std::ios::in);
    if (VertexShaderStream.is_open()) {
        std::stringstream sstr;
        sstr << VertexShaderStream.rdbuf();
        VertexShaderCode = sstr.str();
        VertexShaderStream.close();
    }
    else {
        printf("Impossible to open %s. Are you in the right directory? Don't forget to read the FAQ!\n", vertex_file_path.c_str());
        getchar();
        return 0;
    }

	// fragment 셰이더 코드 읽기
    std::string FragmentShaderCode;
    std::ifstream FragmentShaderStream(fragment_file_path.c_str(), std::ios::in);
    if (FragmentShaderStream.is_open()) {
        std::stringstream sstr;
        sstr << FragmentShaderStream.rdbuf();
        FragmentShaderCode = sstr.str();
        FragmentShaderStream.close();
    }
    //성공여부
    GLint Result = GL_FALSE;
    int InfoLogLength;

    // Compile Vertex Shader
    printf("Compiling shader: %s\n", vertex_file_path.c_str());
    char const* VertexSourcePointer = VertexShaderCode.c_str();
    glShaderSource(VertexShaderID, 1, &VertexSourcePointer, NULL);
    glCompileShader(VertexShaderID);

    // Check Vertex Shader
    glGetShaderiv(VertexShaderID, GL_COMPILE_STATUS, &Result);
    glGetShaderiv(VertexShaderID, GL_INFO_LOG_LENGTH, &InfoLogLength);
    if (InfoLogLength > 0) {
        std::vector<char> VertexShaderErrorMessage(InfoLogLength + 1);
        glGetShaderInfoLog(VertexShaderID, InfoLogLength, NULL, &VertexShaderErrorMessage[0]);
        printf("%s\n", &VertexShaderErrorMessage[0]);
    }

    // Compile Fragment Shader
    printf("Compiling shader : %s\n", fragment_file_path.c_str());
    char const* FragmentSourcePointer = FragmentShaderCode.c_str();
    glShaderSource(FragmentShaderID, 1, &FragmentSourcePointer, NULL);
    glCompileShader(FragmentShaderID);

    // Check Fragment Shader
    glGetShaderiv(FragmentShaderID, GL_COMPILE_STATUS, &Result);
    glGetShaderiv(FragmentShaderID, GL_INFO_LOG_LENGTH, &InfoLogLength);
    if (InfoLogLength > 0) {
        std::vector<char> FragmentShaderErrorMessage(InfoLogLength + 1);
        glGetShaderInfoLog(FragmentShaderID, InfoLogLength, NULL, &FragmentShaderErrorMessage[0]);
        printf("%s\n", &FragmentShaderErrorMessage[0]);
    }

    // Link the program
    printf("Linking program\n");
    GLuint ProgramID = glCreateProgram();
    glAttachShader(ProgramID, VertexShaderID);
    glAttachShader(ProgramID, FragmentShaderID);
    glLinkProgram(ProgramID);

    // Check the program
    glGetProgramiv(ProgramID, GL_LINK_STATUS, &Result);
    glGetProgramiv(ProgramID, GL_INFO_LOG_LENGTH, &InfoLogLength);
    if (InfoLogLength > 0) {
        std::vector<char> ProgramErrorMessage(InfoLogLength + 1);
        glGetProgramInfoLog(ProgramID, InfoLogLength, NULL, &ProgramErrorMessage[0]);
        printf("%s\n", &ProgramErrorMessage[0]);
    }

    glDetachShader(ProgramID, VertexShaderID);
    glDetachShader(ProgramID, FragmentShaderID);

    glDeleteShader(VertexShaderID);
    glDeleteShader(FragmentShaderID);

    return ProgramID;
	}

The Update_mesh function uploads data to the GPU buffer within a given VAO and sets the vertex attribute pointer

![image](https://github.com/user-attachments/assets/c46abcc4-0df3-46e5-8e3a-9e31a40b0521)

Create Sphere Mesh: Use sphere_scene.cpp to create a sphere

![image](https://github.com/user-attachments/assets/32dedbc1-a0a0-44fd-80ad-a54e13103d14)

![image](https://github.com/user-attachments/assets/bdffb946-a399-4b2e-95f3-be7596204e7e)

The main function takes shaders from the files "Pong.vert" and "Pong.frag", creates sphere mesh, sets shaders and transformation matrices, and renders spheres with Phong shading

![image](https://github.com/user-attachments/assets/9a18cdb7-ed36-4845-bb78-fd671355673b)

![image](https://github.com/user-attachments/assets/81783c6b-7e16-4bc1-b44d-fc541668cb1d)

Phong.vert

![image](https://github.com/user-attachments/assets/a3bbf498-5d6e-49e6-a455-7e1efd82a877)

1. Take the position of the vertex in the model space and the normal vector as input.
2. Get the model, view, projection matrix (model, view, projection) as a uniform variable from the main code.
3.Convert the position of the vertex from model space to world space and hand it over to the fragment shader
4.The normal vector also transforms from model space to world space to the fragment shader
5.Convert the position of the vertex to clip space and assign it to an OpenGL embedded variable, gl_Position.

Phong.frag

![image](https://github.com/user-attachments/assets/dd59f95a-c4be-487a-bfa6-e0af53f3c389)

1. It receives as input the fragment position and normal vector in the interpolated world space from the vertex shader.
2. Receive lighting information and material information as variables from the main code.
3. Ambient light: Adjust the intensity of ambient light by multiplying the material's ambient light reflectance by an arbitrary coefficient of 0.2
4. Diffuse light:
vec3 normal = normalize;: Normalize the normal vector
vec3 lightDir = normalize(lightPos - FragPos);: Calculates and normalizes the direction vector from the fragment to the light source.
float diff = max(normal, lightDir, 0.0);: Calculate the intensity of light using the angle (internal) between the normal and the direction of the light source (N·L). If the light comes from behind the surface, it becomes negative, so make it zero using max(..., 0.0).
vec3 diffuse = kd * diff;: determine the diffuse reflection color by multiplying the calculated intensity of light by the diffuse reflectance of the material.
5. Phong:
vec3 viewDir = normalize(viewPos - FragPos);: Calculates and normalizes the orientation vector from the fragment to the camera.
vec3 halfwayDir = normalize(lightDir + viewDir);: Calculates the intermediate vector used by the Blinn-Phong model.
float spec = pow(max(normal, halfwayDir, 0.0), shine business);: Calculate the intensity of the highlight using the angle between the normal and intermediate vectors (N·H) and power it to the shine business value to adjust the concentration of the highlight.
vec3 specific = ks * specific * diff;: multiply the calculated intensity of the highlight by the regular reflectance of the material. The diffuse reflection intensity is additionally multiplied so that the highlight appears only in the direct contact of the light, and the intensity is also adjusted.
6. final
vec3 result = (ambient + diffuse + specific) * lightColor;: Combine the ambient, diffuse, and specular components calculated above and multiply the color of the light source to obtain the final illumination color.
result = pow(result, vec3(1.0/2.2));: Performs gamma calibration. Computer monitors have a nonlinear brightness response, so if you leave the calculated linear color value as it is, it may look darker or brighter than you intended. This calibration represents a more visually accurate brightness.
outColor = vec4 (result, 1.0;: final calculated color) and the alpha value as the output color of the fragment.
   
