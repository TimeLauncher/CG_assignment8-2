#version 330 core

in vec4 wPosition;
in vec4 wNormal;
out vec4 outColor;

vec4 shade(vec4 wp, vec4 wn) {
    vec3 normal = normalize(wn.xyz);
    vec3 lightDir = normalize(vec3(-1.0, 1.0, 1.0));      // ���� ����
    vec3 viewDir = normalize(vec3(0.0, 0.0, 3.0) - wp.xyz); // ī�޶� ��ġ - world pos

    // ��ǻ�� ����
    vec3 baseColor = vec3(0.8, 0.3, 0.1); // �⺻ ��
    float diff = max(dot(normal, lightDir), 0.0);

    // ����ŧ�� ����
    vec3 reflectDir = reflect(-lightDir, normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32.0); // shininess=32
    vec3 specularColor = vec3(1.0); // ���̶���Ʈ�� ���

    vec3 color = baseColor * diff + specularColor * spec;
    return vec4(color, 1.0);
}

void main() {
    outColor = shade(wPosition, wNormal);
}