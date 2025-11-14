import axios from "axios";

// API Gateway URL - Update this if your API URL changes
const apiBaseUrl = import.meta.env.VITE_API_BASE_URL ?? "https://uk6ks80k8i.execute-api.us-east-1.amazonaws.com/api";

const client = axios.create({
  baseURL: apiBaseUrl,
  timeout: 120000, // Increased timeout for SageMaker requests and file uploads
  // Don't set default Content-Type - let axios set it based on data type
  // For JSON requests, axios will set application/json
  // For FormData, axios will set multipart/form-data with boundary
});

/**
 * Upload document and generate study notes or quiz
 * @param {Object} params - Upload parameters
 * @param {File} params.file - File to upload
 * @param {string} params.requestType - Type of request: "study_notes" or "quiz"
 * @param {string} [params.topic] - Optional topic focus
 * @returns {Promise<Object>} Generation result
 */
export async function uploadDocument({ file, requestType, topic, prompt }) {
  const formData = new FormData();
  formData.append("file", file);
  formData.append("requestType", requestType || "study_notes");
  if (topic) {
    formData.append("topic", topic);
  }
  if (prompt) {
    formData.append("prompt", prompt);
  }

  // Don't set Content-Type header - axios will set it automatically with boundary for multipart/form-data
  const response = await client.post("/generate", formData, {
    headers: {
      // Let axios set Content-Type automatically with boundary for multipart/form-data
    },
    timeout: 120000 // 120 seconds for file processing and SageMaker
  });

  return response.data;
}

/**
 * Generate text from a simple message (no file upload)
 * @param {string} message - Text to generate from
 * @returns {Promise<Object>} Generation result
 */
export async function generateText(message) {
  const response = await client.post("/generate", {
    message: message
  });

  return response.data;
}

/**
 * Chat with the AI (RAG-enabled)
 * @param {string} message - Chat message
 * @param {string} [historyId] - Optional history ID for conversation continuity
 * @returns {Promise<Object>} Chat response
 */
export async function sendChat(message, historyId = null) {
  const response = await client.post("/chat", {
    message: message,
    history_id: historyId
  });

  return response.data;
}

/**
 * Get conversation history
 * @returns {Promise<Array>} History items
 */
export async function fetchHistory() {
  const response = await client.get("/history");
  // API returns { items: [...] }, so extract items array
  return response.data.items || response.data || [];
}

/**
 * Health check
 * @returns {Promise<Object>} Health status
 */
export async function checkHealth() {
  const response = await client.get("/health");
  return response.data;
}

/**
 * Get API base URL
 * @returns {string} API base URL
 */
export function getApiBaseUrl() {
  return apiBaseUrl;
}
