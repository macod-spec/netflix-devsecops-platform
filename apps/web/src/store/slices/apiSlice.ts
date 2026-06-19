import { createApi, fetchBaseQuery } from "@reduxjs/toolkit/query/react";
import { BACKEND_API_BASE_URL } from "src/constant";

export const tmdbApi = createApi({
  reducerPath: "tmdbApi",
  baseQuery: fetchBaseQuery({ baseUrl: BACKEND_API_BASE_URL }),
  endpoints: (build) => ({}),
});
