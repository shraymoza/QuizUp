import { useMutation } from "@tanstack/react-query";

import { uploadDocument } from "../services/api.js";

export function useUploadGeneration() {
  return useMutation({
    mutationFn: uploadDocument
  });
}
