# Quick Start Guide - Frontend Integration

## ✅ Integration Complete!

Your React frontend is now integrated with the QuizUp RAG API!

### API URL
```
https://uk6ks80k8i.execute-api.us-east-1.amazonaws.com/api
```

## 🚀 Getting Started

### Step 1: Install Dependencies (if needed)

```bash
cd frontend
npm install
```

### Step 2: Start Development Server

```bash
npm run dev
```

The app will open at `http://localhost:5173`

### Step 3: Test the Integration

1. **Upload Page** (`/upload`):
   - Upload a PDF file
   - Select request type (study_notes or quiz)
   - Optionally add a topic focus
   - Click "Generate"
   - Wait for response (may take 30-60 seconds for first request)

2. **History Page** (`/history`):
   - View all generation history
   - See generated study notes and quizzes
   - Check creation dates and document keys

## 📋 What's Working

### ✅ File Upload & Generation
- Upload PDF files
- Generate study notes
- Generate quizzes
- Topic-focused generation

### ✅ History Viewing
- View generation history
- See all past generations
- Display document information

### ✅ API Integration
- Connected to API Gateway
- All endpoints working
- Error handling in place
- Loading states implemented

## 🎯 API Functions Available

```javascript
import { 
  uploadDocument, 
  generateText, 
  sendChat, 
  fetchHistory, 
  checkHealth 
} from './services/api';

// Upload document (existing)
await uploadDocument({
  file: fileObject,
  requestType: 'study_notes',
  topic: 'Machine Learning'
});

// Generate text (new - simple text generation)
await generateText('Summarize: Machine learning is a subset of AI.');

// Chat with RAG (new - chat interface)
await sendChat('What is machine learning?', historyId);

// Get history (updated)
await fetchHistory();

// Health check (new)
await checkHealth();
```

## 🔧 Configuration

### API URL Configuration

The API URL is configured in `src/services/api.js`:

```javascript
const apiBaseUrl = import.meta.env.VITE_API_BASE_URL ?? 
  "https://uk6ks80k8i.execute-api.us-east-1.amazonaws.com/api";
```

**To change API URL:**
1. Create `.env` file in `frontend` directory:
   ```env
   VITE_API_BASE_URL=https://uk6ks80k8i.execute-api.us-east-1.amazonaws.com/api
   ```
2. Or update `apiBaseUrl` in `src/services/api.js`
3. Restart dev server

## 🚨 Troubleshooting

### Issue 1: CORS Error
**Error**: `Access to fetch at '...' has been blocked by CORS policy`

**Fix**: 
- CORS is configured in API Gateway
- Verify API Gateway has CORS enabled
- Check browser console for specific error
- Try testing from browser console first

### Issue 2: API Returns 404
**Error**: `404 Not Found`

**Fix**:
- Verify API URL is correct
- Check API Gateway routes are deployed
- Verify endpoint paths are correct

### Issue 3: History Returns Empty
**Error**: History shows empty even after generating

**Fix**:
- Check API response format
- Verify `fetchHistory()` extracts `items` array
- Check S3 bucket has outputs
- Verify Lambda has S3 read permissions

### Issue 4: File Upload Fails
**Error**: `Uploaded file was empty` or timeout

**Fix**:
- Check file size (should be reasonable)
- Verify file is selected
- Check network connection
- Verify API Gateway supports multipart/form-data
- Increase timeout if needed (already set to 60 seconds)

## 🎉 Ready to Use!

Your frontend is ready to use! Start the dev server and test the integration.

**Quick Test:**
1. Start dev server: `npm run dev`
2. Go to Upload page
3. Upload a PDF
4. Click Generate
5. Check History page for results

## 📚 Next Steps

1. ✅ **Test the integration**: Start dev server and test upload
2. ✅ **Verify history**: Check that history page works
3. ⚪ **Add chat feature**: Create chat component if needed
4. ⚪ **Add text generation**: Add simple text generation if needed
5. ⚪ **Deploy frontend**: Deploy to production when ready

## 🔗 Documentation

- **Integration Guide**: `INTEGRATION_COMPLETE.md`
- **API Service**: `src/services/api.js`
- **Frontend Integration**: `../FRONTEND_INTEGRATION_GUIDE.md`

Happy coding! 🎉

