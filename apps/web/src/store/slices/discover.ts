import { PayloadAction, createSlice, isAnyOf } from "@reduxjs/toolkit";
import { MEDIA_TYPE, PaginatedMovieResult } from "src/types/Common";
import { MovieDetail } from "src/types/Movie";
import { tmdbApi } from "./apiSlice";

type DiscoverState = Record<string, Record<string, PaginatedMovieResult>>;

const initialState: DiscoverState = {};

export const initialItemState: PaginatedMovieResult = {
  page: 0,
  results: [],
  total_pages: 0,
  total_results: 0,
};

const extendedApi = tmdbApi.injectEndpoints({
  endpoints: (build) => ({
    getVideosByMediaTypeAndGenreId: build.query<
      PaginatedMovieResult & { mediaType: MEDIA_TYPE; itemKey: string },
      { mediaType: MEDIA_TYPE; genreId: number; page: number }
    >({
      query: ({ mediaType, genreId, page }) => ({
        url: `/discover/${mediaType}`,
        params: { with_genres: genreId, page },
      }),
      transformResponse: (
        response: PaginatedMovieResult,
        _,
        { mediaType, genreId }
      ) => ({
        ...response,
        mediaType,
        itemKey: String(genreId),
      }),
    }),

    getVideosByMediaTypeAndCustomGenre: build.query<
      PaginatedMovieResult & { mediaType: MEDIA_TYPE; itemKey: string },
      { mediaType: MEDIA_TYPE; apiString: string; page: number }
    >({
      query: ({ mediaType, apiString, page }) => ({
        url: `/${mediaType}/${apiString}`,
        params: { page },
      }),
      transformResponse: (
        response: PaginatedMovieResult,
        _,
        { mediaType, apiString }
      ) => ({
        ...response,
        mediaType,
        itemKey: apiString,
      }),
    }),

    getAppendedVideos: build.query<
      MovieDetail,
      { mediaType: MEDIA_TYPE; id: number }
    >({
      query: ({ mediaType, id }) => ({
        url: `/${mediaType}/${id}`,
        params: { append_to_response: "videos" },
      }),
    }),

    getSimilarVideos: build.query<
      PaginatedMovieResult,
      { mediaType: MEDIA_TYPE; id: number }
    >({
      query: ({ mediaType, id }) => ({
        url: `/${mediaType}/${id}/similar`,
      }),
    }),
  }),
});

const discoverSlice = createSlice({
  name: "discover",
  initialState,
  reducers: {
    setNextPage: (
      state,
      action: PayloadAction<{ mediaType: MEDIA_TYPE; itemKey: string | number }>
    ) => {
      const { mediaType, itemKey } = action.payload;
      const key = String(itemKey);

      if (state[mediaType]?.[key]) {
        state[mediaType][key].page += 1;
      }
    },

    initiateItem: (
      state,
      action: PayloadAction<{ mediaType: MEDIA_TYPE; itemKey: string | number }>
    ) => {
      const { mediaType, itemKey } = action.payload;
      const key = String(itemKey);

      if (!state[mediaType]) {
        state[mediaType] = {};
      }

      if (!state[mediaType][key]) {
        state[mediaType][key] = { ...initialItemState };
      }
    },
  },

  extraReducers(builder) {
    builder.addMatcher(
      isAnyOf(
        extendedApi.endpoints.getVideosByMediaTypeAndCustomGenre.matchFulfilled,
        extendedApi.endpoints.getVideosByMediaTypeAndGenreId.matchFulfilled
      ),
      (state, action) => {
        const {
          page,
          results,
          total_pages,
          total_results,
          mediaType,
          itemKey,
        } = action.payload;

        if (!state[mediaType]) {
          state[mediaType] = {};
        }

        if (!state[mediaType][itemKey]) {
          state[mediaType][itemKey] = { ...initialItemState };
        }

        state[mediaType][itemKey].page = page;
        state[mediaType][itemKey].results.push(...results);
        state[mediaType][itemKey].total_pages = total_pages;
        state[mediaType][itemKey].total_results = total_results;
      }
    );
  },
});

export const { setNextPage, initiateItem } = discoverSlice.actions;

export const {
  useGetVideosByMediaTypeAndGenreIdQuery,
  useLazyGetVideosByMediaTypeAndGenreIdQuery,
  useGetVideosByMediaTypeAndCustomGenreQuery,
  useLazyGetVideosByMediaTypeAndCustomGenreQuery,
  useGetAppendedVideosQuery,
  useLazyGetAppendedVideosQuery,
  useGetSimilarVideosQuery,
  useLazyGetSimilarVideosQuery,
} = extendedApi;

export default discoverSlice.reducer;