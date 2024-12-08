import { useState, useEffect } from 'react';
import { apiClient } from '../api/client';

interface HealthResponse {
  status: string;
  time: string;
}

export const HealthCheck = () => {
  const [health, setHealth] = useState<HealthResponse | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const checkHealth = async () => {
      try {
        const response = await apiClient.get<HealthResponse>('/health');
        setHealth(response.data);
        setError(null);
      } catch (err) {
        setError('Failed to connect to backend');
        console.error('Health check error:', err);
      }
    };

    checkHealth();
  }, []);

  return (
    <div style={{ padding: '20px' }}>
      <h2>Backend Health Check</h2>
      {health ? (
        <div>
          <p>Status: {health.status}</p>
          <p>Server Time: {health.time}</p>
        </div>
      ) : error ? (
        <p style={{ color: 'red' }}>{error}</p>
      ) : (
        <p>Loading...</p>
      )}
    </div>
  );
};
